import subprocess
import os
import glob
import json
from PyQt5.QtWidgets import QMainWindow, QHeaderView, QTableWidgetItem, QApplication
from PyQt5 import uic
from PIL import Image


#################################################
####    FUNCTIONS ####
#################################################

def check_directory_exists(path: str):
    """
    Check if directory exists
    :param path:
    :return:
    """
    if not os.path.exists(path):
        # print("Folder does not exist.")
        return False
    if not os.path.isdir(path):
        # print("Path is not a folder.")
        return False
    return True

def find_file_in_path(path: str, file_name: str) -> bool:
    files = os.listdir(path)
    return any(file.startswith(file_name) for file in files)

def check_meshroom_batch_exists(path: str) -> bool:
    """
    Takes meshroom_batch path and checks if it exists or not
    :param path: meshroom_batch directory
    :return:
    """
    if not check_directory_exists(path):
        print("WARNING:", "Meshroom directory is wrong")
        return False

    # meshroom_batch = os.path.join(path, "meshroom_batch.exe")
    # test = os.path.isfile(meshroom_batch)

    if find_file_in_path(path, "meshroom_batch"):
        # print("Meshroom_batch found")
        return True
    else:
        print("WARNING:", "Meshroom directory doesn't contain 'meshroom_batch'")
        return False

def check_task_path(path: str, name: str, task: str = "") -> bool:
    ## Needs to check if folder with image name exists to validate
    """
    Checks if given directory exists and isn't used
    :param path: work directory
    :param name: name that will be used for creating a
    :param task: task for which the directory is being validated (used for debug message only)
    :return:
    """
    ## add space to end of task in case it doesn't have it
    task += " " if not task.endswith(" ") and task != "" else ""

    if not check_directory_exists(path):
        print("WARNING:", f"Provided {task}directory does not exist")
        return False

    if check_directory_exists(os.path.join(path, name)):
        print("WARNING:", f"Folder with name '{name}' already exists in provided {task}directory")
        return False

    return True


##########################################################################################
####    BLENDER    #######
##########################################################################################

def blender_unwrap(blender_dir: str, import_path: str, export_path: str):
    """
    Import mesh to blender for unwrap
    :param blender_dir:
    :param import_path:
    :param export_path:
    :return:
    """
    blender_exe = os.path.join(blender_dir, "blender")
    # Start Blender process
    blender_cmd = [f"{blender_exe}", "--background"]
    subprocess.run(blender_cmd)

    # Import, Unwrap, Pack, and Export
    # Python script as string to be run in command line
    # No indent, or it might give errors
    unwrap_script = f"""
import bpy

# Select all objects
bpy.ops.object.select_all(action='SELECT')

# Delete selected objects
bpy.ops.object.delete(use_global=False, confirm=False)

# Import object
bpy.ops.import_scene.obj(filepath=r'{import_path}')

# Switch to edit mode
obj = bpy.context.scene.objects[0]
bpy.context.view_layer.objects.active = obj
bpy.ops.object.mode_set(mode='EDIT')

## Perform UV unwrapping
bpy.ops.uv.smart_project(island_margin=0.002)

## Pack UV islands
bpy.ops.uv.select_all(action='SELECT')
########################################################################
##### Disabled until pack_islands is fixed in blender3.6.1 hopefully #####
# bpy.ops.uv.pack_islands()
########################################################################

## Switch back to object mode
bpy.ops.object.mode_set(mode='OBJECT')

## Export object
bpy.ops.export_scene.obj(filepath=r'{export_path}')

## Quit
##bpy.ops.wm.quit_blender()
    """

    unwrap_cmd = [f"{blender_exe}", "--background", "--python-expr", unwrap_script]
    subprocess.run(unwrap_cmd)


def check_blender_exe_exists(path: str) -> bool:
    if not check_directory_exists(path):
        print("WARNING:", "Blender directory is wrong")
        return False

    # blender_exe = os.path.join(path, "blender.exe")
    # test = os.path.isfile(blender_exe)
    if find_file_in_path(path, "blender"):
        # print("Blender.exe found")
        return True
    else:
        print("WARNING:", "Blender directory doesn't contain 'blender.exe'")
        return False


def obj_import_path(work_path: str, name: str, node: str) -> str:
    """
    Returns path of the .obj file in the save directory of the selected node
    :param work_path:
    :param name:
    :param node:
    :return:
    """
    node_dir = os.path.join(work_path, name, "MeshroomCache", node)

    ## get all 'uid' directories with weird names
    uid_dirs = [f for f in os.listdir(node_dir) if os.path.isdir(os.path.join(node_dir, f))]
    if not uid_dirs:
        print("WARNING:", f"Mesh could not be found in {node} folder")
        return ""

    sorted_uids = sorted(uid_dirs, key=lambda f: os.path.getmtime(os.path.join(node_dir, f)), reverse=True)

    latest_uid = os.path.join(node_dir, sorted_uids[0])

    ## there's supposed to be only one .obj file per directory
    obj = [f for f in os.listdir(latest_uid) if f.endswith(".obj")]
    print(f"{obj[0]} found in {latest_uid}")
    return os.path.join(latest_uid, obj[0])


def obj_export_path(work_path: str, name: str) -> str:
    """
    Create export path for unwrapped mesh
    :param work_path:
    :param name:
    :return: path of mesh to be exported from blender
    """
    unwrapped_dir = os.path.join(work_path, name, "MeshroomCache", "UnwrappedMesh")
    if not os.path.exists(unwrapped_dir):
        os.mkdir(unwrapped_dir)
        print(unwrapped_dir, "created")
    return os.path.join(unwrapped_dir, "mesh.obj")


###############################################
####    UI    ####
###############################################

class ProcessorGUI(QMainWindow):
    data = {
        "meshroom_dir": "",
        "blender_dir": "",
        "image_dir": "",
        "work_dir": "",
        "output_dir": "",
        "custom_pipeline": "",
        # "to_node": "",
    }
    data_file = "data.json"
    custom_pipeline = ""
    to_node = ""
    current_cache = ""

    galleries = {}

    def __init__(self):
        super(ProcessorGUI, self).__init__(None)
        uic.loadUi(self.find_ui_file(), self)
        self.setFixedSize(self.size().width(), self.size().height())
        self.show()
        self.load()

        ## Buttons
        self.button_save.clicked.connect(self.save)
        self.button_load.clicked.connect(self.load)
        self.button_start.clicked.connect(self.start)
        self.button_validate.clicked.connect(self.validate_inputs)
        self.button_info.clicked.connect(self.info)

        ## Table
        header = self.table.horizontalHeader()
        header.setSectionResizeMode(0, QHeaderView.Fixed)
        header.setSectionResizeMode(1, QHeaderView.Stretch)
        header.resizeSection(0, 420)

        ## Inputs
        text_fields = [
            self.line_meshroom_dir,
            self.line_blender_dir,
            self.line_work_dir,
            self.line_image_dir,
            self.line_output_dir,
            self.line_pipeline,
        ]

        for line in text_fields:
            line.textEdited.connect(self.get_parameters)
            line.returnPressed.connect(self.validate_inputs)

    def find_ui_file(self) -> str:
        # Get the current working directory
        cwd = os.getcwd()
        # Get a list of files in the directory
        files = os.listdir(cwd)
        # Find the first file ending with ".ui"
        ui_file = next((file for file in files if file.endswith(".ui")), None)

        if ui_file is not None:
            return ui_file
        else:
            print(".ui file not found")
            return ""

    def validate_inputs(self) -> bool:
        ## Test if inputs are valid

        is_valid = True
        name = self.get_name()
        print("#" * 80)
        if not check_meshroom_batch_exists(self.data["meshroom_dir"]):
            is_valid = False
        if not check_blender_exe_exists(self.data["blender_dir"]):
            is_valid = False
        if not check_task_path(self.data["work_dir"], name, "work"):
            is_valid = False
        if not check_task_path(self.data["output_dir"], name, "output"):
            is_valid = False
        if self.get_image_folders() <= 0:
            is_valid = False
        if self.get_pre_texturing_node() == "":
            is_valid = False


        print("#" * 80)

        if is_valid:
            print("All inputs are good")
            self.button_start.setEnabled(True)
            return True
        else:
            self.button_start.setEnabled(False)
            return False

    def get_parameters(self):
        self.data["meshroom_dir"] = self.line_meshroom_dir.text()
        self.data["blender_dir"] = self.line_blender_dir.text()
        self.data["work_dir"] = self.line_work_dir.text()
        self.data["image_dir"] = self.line_image_dir.text()
        self.data["output_dir"] = self.line_output_dir.text()
        self.data["custom_pipeline"] = self.line_pipeline.text()


    def set_parameters(self):
        self.line_meshroom_dir.setText(str(self.data["meshroom_dir"]))
        self.line_blender_dir.setText(str(self.data["blender_dir"]))
        self.line_work_dir.setText(str(self.data["work_dir"]))
        self.line_image_dir.setText(str(self.data["image_dir"]))
        self.line_output_dir.setText(str(self.data["output_dir"]))
        self.line_pipeline.setText(str(self.data["custom_pipeline"]))

    def check_custom_pipeline(self, path: str) -> str:
        """
        Checks if custom pipeline provided is a real meshroom graph file, or checks current directory for .mg files
        :param path: pipeline file, meshroom graph template to use
        :return: valid template path
        """
        ## First check if input path is empty,
        ## if not empty check if path is valid
        if path != "":
            if not os.path.exists(path):
                print("WARNING:", "Pipeline path input wrong")
                return ""
            if os.path.isdir(path):
                print("WARNING:", "Pipeline path  input is a folder, meshroom graph file expected")
                return ""
            _, ext = os.path.splitext(path)  ## splits path from its extension
            if ext == ".mg":
                return path

        ## Second if no path is given, check in current working directory for file with .mg extension
        cwd = os.getcwd()
        has_template_pipeline = False
        for file in os.listdir(cwd):
            if file.endswith(".mg"):
                path = file
                has_template_pipeline = True
        ## If .mg file in script directory doesn't exist print warning
        if not has_template_pipeline:
            print("WARNING:", "No pipeline input, template not found")
            return ""
        else:
            print(f"No pipeline input, using template - {os.path.basename(path)}")
            return path

    def get_pre_texturing_node(self) -> str:
        """
        gets the node that texturing node uses as inputMesh
        :return: node name
        """
        ## Read the template .mg file
        pipeline_file = self.check_custom_pipeline(self.data["custom_pipeline"])
        if pipeline_file == "":
            return ""
        file = open(pipeline_file, "r")
        json_data = file.read()
        loaded_data = json.loads(json_data)

        ## Get texturing node name
        texturing_node = self.get_texturing_node_name(loaded_data)
        if texturing_node == "":
            return ""

        ## Get texturing node inputMesh name
        input_mesh_data = loaded_data['graph'][texturing_node]['inputs']['inputMesh']
        to_node = input_mesh_data.strip("{}").split('_')[0]

        print(f"Texturing inputMesh node is {to_node}")

        self.custom_pipeline = pipeline_file
        self.to_node = to_node
        ## Return name
        return to_node

    def get_texturing_node_name(self, loaded_data: dict):
        """
        get full name of texturing node including suffix
        :param loaded_data:
        :return:
        """
        texturing_node = next((key for key in loaded_data['graph'] if key.startswith('Texturing')), None)
        if not texturing_node:
            print("WARNING:", "No Texturing node found in graph")
            return ""
        return texturing_node

    def start(self):
        self.save()
        ## Loop over every input image folder and make a mesh for each
        total_galleries = len(self.galleries)
        print(total_galleries)

        ## validating in case something changed in folders between last validation and start
        # if not self.validate_inputs():
        #     return

        for name in self.galleries:
            print(f"Processing {name}")
            self.single_obj_meshing(name)
        print("Processing finished")
        self.validate_inputs()

    def single_obj_meshing(self, name: str):
        """
        performs remesh of a single image gallery
        :param name: name of gallery to be meshed
        :return:
        """
    
        ## Same data, but with image dirs replaced with current gallery
        single_obj_data = self.data.copy()
        gallery_path = os.path.join(self.data["image_dir"], name)
        print("Main iamge directory: ", self.data["image_dir"])
        print(f"Current Image Directory: {gallery_path}")
        single_obj_data["image_dir"] = gallery_path

        print("Meshing")
        command = self.make_batch_command(single_obj_data, name)
        print("Running:", command)
        subprocess.run(command)

        print("Mesh Created")
        # name = self.get_name()
        import_path = obj_import_path(single_obj_data["work_dir"], name, self.to_node)
        export_path = obj_export_path(single_obj_data["work_dir"], name)

        print("Unwrapping")
        blender_unwrap(single_obj_data["blender_dir"], import_path, export_path)

        print("Texturing")
        ## Edit save to use unwrapped Mesh
        self.edit_graph_for_texturing(export_path)
        # print("After edit")
        command = self.make_compute_command(self.current_cache)
        print(f"Running: {command}")
        subprocess.run(command)


        print("\n", f"Done with {name}")
        self.rename_completed_image_dir(gallery_path)
        print("#" * 80)

    def make_batch_command(self, data: dict, name: str) -> str:
        """
        makes a bash command that runs meshroom_batch.exe
        :param name:
        :param data: data to make command
        :return:
        """
        # pipeline = check_custom_pipeline_valid(data["custom_pipeline"])
        pipeline = self.custom_pipeline

        # name = self.get_name()
        save_path = os.path.join(data["work_dir"], name)
        ## Crashes if save_path already exists, should be prevented by validating
        os.mkdir(save_path)
        save_dir = os.path.join(save_path, f"{name}.mg")
        self.current_cache = save_dir

        meshroom_batch = os.path.join(data["meshroom_dir"], "meshroom_batch")
        # to_node = data["to_node"]
        to_node = self.to_node
        image_dir = data["image_dir"]
        output_dir = os.path.join(data["output_dir"], name)

        # command = self.format_batch_command(meshroom_batch, image_dir, pipeline, to_node, save_dir, output_dir)
        command = f"{meshroom_batch} --input {image_dir} --pipeline {pipeline} --toNode {to_node} --save {save_dir} --output {output_dir}"

        return command

    def make_compute_command(self, current_cache: str) -> str:
        """
        makes a bash command that runs meshroom_compute.exe to texture and output mesh
        :return:
        """
        ## Get Meshroom_compute_exe
        meshroom_compute = os.path.join(self.data["meshroom_dir"], "meshroom_compute")
        print(meshroom_compute)
        ## Get current Graph file
        graph = current_cache
        print(current_cache)

        to_node = "Publish"
        ## format command

        return f"{meshroom_compute} {graph} --toNode {to_node}"

    def edit_graph_for_texturing(self, export_path: str):
        ## load save.mg file
        save_dir = self.current_cache
        try:
            with open(save_dir, "r") as file:
                loaded_graph = json.load(file)
        except (FileNotFoundError, json.JSONDecodeError):
            print("WARNING:", f"Save file {os.path.basename(save_dir)}, not found")
            return

        ## find inputMesh key
        texturing_node = self.get_texturing_node_name(loaded_graph)
        if texturing_node == "":
            return
        ## replace inputMesh value with UnwrappedMesh

        loaded_graph["graph"][texturing_node]["inputs"]["inputMesh"] = export_path

        try:
            with open(save_dir, "w") as file:
                json.dump(loaded_graph, file, indent=4)
            print(f"Texturing inputMesh replaced with {export_path}")
        except IOError:
            print("WARNING:", "An error occurred while writing the modified data to the file.")

    def rename_completed_image_dir(self, completed_path: str):
        """
        run this after finishing a photoscan, adds a . to the image folder to track it as ignored
        :return:
        """
        # Specify the directory path

        # Extract the folder name from the directory path
        folder_name = os.path.basename(completed_path)
        new_folder_name = '.' + folder_name
        new_path = completed_path.replace(folder_name, new_folder_name)

        # Rename the directory
        os.rename(completed_path, new_path)

    def get_image_folders(self) -> int:
        path = self.data["image_dir"]
        try:
            image_dirs = [directory for directory in os.listdir(path) if os.path.isdir(os.path.join(path, directory))]
        except OSError:
            print("WARNING:", "Error occurred getting image directories")
            return -1

        self.galleries.clear()

        ## Count the images in given directories
        for d in image_dirs:
            ## Filter out the ones that start with .
            if d.startswith("."):
                continue
            # print(d)
            name = os.path.basename(d)
            count = self.count_images_in_directory(os.path.join(path, d))
            ## Remove ones with 0 images
            if count <= 0:
                continue
            self.galleries[name] = count

        galleries = len(self.galleries)

        if galleries <= 0:
            print("WARNING:", "No image galleries found in image directory")
        self.list_galleries()

        return galleries

    def count_images_in_directory(self, path: str) -> int:
        """
        Counts number of images in provided directory
        :param path: images directory
        :return:
        """
        if not check_directory_exists(path):
            print("WARNING:", "Images directory not valid")
            return -1
        count = 0
        for filename in os.listdir(path):
            file_path = os.path.join(path, filename)
            if os.path.isfile(file_path):
                try:
                    Image.open(file_path)
                    count += 1
                except (IOError, SyntaxError):
                    pass
        print(f"Image directory  '{os.path.basename(path)}' found. {count} - images found")
        return count

    def list_galleries(self):
        self.table.clearContents()
        self.table.setRowCount(0)
        self.table.setRowCount(len(self.galleries))
        for row, (name, value) in enumerate(self.galleries.items()):
            name_item = QTableWidgetItem(name)
            value_item = QTableWidgetItem(str(value))
            self.table.setItem(row, 0, name_item)
            self.table.setItem(row, 1, value_item)

    def save(self):
        """
        Saves data file in the same directory as the script
        :return:
        """
        self.get_parameters()

        filtered_data = self.filter_data(self.data)
        json_file = open(self.data_file, "w")
        json.dump(filtered_data, json_file, indent=4)
        json_file.close()

    def load(self):
        try:
            with open(self.data_file, "r") as file:
                json_data = file.read()
            loaded_data = json.loads(json_data)
            self.data = self.filter_data(loaded_data)
        except (FileNotFoundError, json.JSONDecodeError):
            print("Data file invalid or missing, initializing without data")
            # Set empty strings for each key if the file is not found or is invalid JSON

            ## This may break if data dictionary has been modified, but it's a sacrifice I'm willing to make
            self.data = {key: "" for key in self.data}

            ## Fallback option if data keys have been modified
            # self.data = {
            #     "meshroom_dir": "",
            #     "blender_dir": "",
            #     "image_dir": "",
            #     "work_dir": "",
            #     "custom_pipeline": "",
            #     "output_dir": ""
            # }
        self.validate_inputs()
        self.set_parameters()

    def filter_data(self, data: dict) -> dict:
        filtered_data = {
            "meshroom_dir": data.get("meshroom_dir"),
            "blender_dir": data.get("blender_dir"),
            "image_dir": data.get("image_dir"),
            "work_dir": data.get("work_dir"),
            "custom_pipeline": data.get("custom_pipeline"),
            "output_dir": data.get("output_dir"),
            # "to_node": data.get("to_node")
        }
        return filtered_data

    def info(self):
        print("INFO:", "Explanation, or link to github, idk")

    def get_name(self):
        return os.path.basename(self.data["image_dir"])


def main():
    app = QApplication([])
    window = ProcessorGUI()
    app.exec_()


if __name__ == '__main__':
    main()
