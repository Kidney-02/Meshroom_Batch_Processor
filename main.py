from PIL import Image
import subprocess
import os
from PyQt5.QtWidgets import *
from PyQt5 import uic
import json


#################################################
####    FUNCTIONS ####
#################################################

def check_directory_exists(path: str):
    """
    Check if work directory exists
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


def check_directory_empty(path: str) -> int:
    """
    checks if given directory is empty
    :param path:
    :return:
    """
    if not check_directory_exists(path):
        return 1  ## does not exist

    ## check if empty
    return 2 if len(os.listdir(path)) != 0 else 0  ## return 0 if empty and 2 if not empty


def check_meshroom_batch_exists(path: str) -> bool:
    """
    Takes meshroom_batch path and checks if it exists or not
    :param path: meshroom_batch directory
    :return:
    """
    if not check_directory_exists(path):
        return False

    meshroom_batch = os.path.join(path, "meshroom_batch.exe")
    test = os.path.isfile(meshroom_batch)
    if test:
        print("Meshroom_batch found")
        return True
    else:
        print("Meshroom directory doesn't contain meshroom_batch.exe")
        return False


def check_work_path(path: str) -> bool:
    """
    Checks if work directory is empty
    :param path: work directory
    :return:
    """
    test = check_directory_empty(path)
    if test == 1:
        print("Work directory does not exist")
        return False
    elif test == 2:
        print("Work directory is not empty")
        return False
    elif test == 0:
        print("Work directory found")
        return True


def count_images_in_directory(path: str) -> int:
    """
    Counts number of images in provided directory
    :param path: images directory
    :return:
    """
    if not check_directory_exists(path):
        print("Images directory not valid")
        return -1
    print("Image dir found")
    count = 0
    for filename in os.listdir(path):
        file_path = os.path.join(path, filename)
        if os.path.isfile(file_path):
            try:
                Image.open(file_path)
                count += 1
            except (IOError, SyntaxError):
                pass
    print(f"Image directory found. {count} images found")
    return count


def check_custom_pipeline_valid(path: str) -> str:
    """
    Checks if custom pipeline provided is a real meshroom graph file (.mg), or checks current directory for a .mg files
    :param path: pipeline file, meshroom graph template to use
    :return: valid template path
    """
    ## First check if input path is empty,
    ## if not empty check if path is valid
    if path != "":
        if not os.path.exists(path):
            print("Pipeline path input wrong")
            return ""
        if os.path.isdir(path):
            print("Pipeline path  input is a folder, meshroom graph expected")
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
        print("No pipeline input, template not found")
        return ""
    else:
        print(f"No pipeline input, using template - {os.path.basename(path)}")
        return path


def check_output_path(path: str) -> bool:
    """
        Checks if output directory is empty
        :param path: output directory
        :return:
        """
    test = check_directory_empty(path)
    if test == 1:
        print("Output directory does not exist")
        return False
    elif test == 2:
        print("Output directory is not empty")
        return False
    elif test == 0:
        print("Output directory found")
        return True


###########################################################################


###############################################
####    DATA    ####
###############################################

## replace with user input later
# meshroom_dir = r"C:\Users\kidne\AppData\Roaming\Meshroom-2023.2.0"  ## Meshroom installation path
# blender_dir = r"C:\Users\kidne\AppData\Roaming\Meshroom-2023.2.0"  ## Blender installation path
# images_dir = r"C:\Users\kidne\OneDrive\Documents\Meshroom\Meshroom\dataset_monstree-master\mini3"
# work_dir = r"C:\Users\kidne\OneDrive\Documents\Meshroom\Meshroom\Test"  ## save and cache path
# custom_pipeline = r"C:\Users\kidne\OneDrive\Documents\Meshroom\Meshroom\_Template\Photogrammetry_Remesh.mg"  ## what pipeline to use default provided
# output_dir = r"C:\Users\kidne\OneDrive\Documents\Meshroom\Meshroom\Output"  ## where to place processed models and textures

# log = ""

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
        "to_node": "MeshResampling",
    }
    data_file = "data.json"

    def __init__(self):
        super(ProcessorGUI, self).__init__()
        uic.loadUi(self.find_UI_file(), self)
        self.setFixedSize(self.size().width(), self.size().height())
        self.show()
        self.load()

        self.button_save.clicked.connect(self.save)
        self.button_load.clicked.connect(self.load)
        self.button_start.clicked.connect(self.start)

        ## Check Inputs
        self.line_meshroom_dir.textChanged.connect(self.get_parameters)
        self.line_blender_dir.textChanged.connect(self.get_parameters)
        self.line_work_dir.textChanged.connect(self.get_parameters)
        self.line_image_dir.textChanged.connect(self.get_parameters)
        self.line_output_dir.textChanged.connect(self.get_parameters)
        self.line_pipeline.textChanged.connect(self.get_parameters)

    def find_UI_file(self) -> str:
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

    def test_if_inputs_valid(self, data: dict) -> bool:
        ## Test if inputs are valid
        if not check_meshroom_batch_exists(data["meshroom_dir"]):
            return False

        if not check_work_path(data["work_dir"]):
            return False

        if count_images_in_directory(data["image_dir"]) <= 0:
            return False

        if check_custom_pipeline_valid(data["custom_pipeline"]) == "":
            return False

        if not check_output_path(data["output_dir"]):
            return False
        print("All inputs are good")
        return True

    def format_bash_command(self, meshroom_batch: str, images: str, pipeline: str, to_node: str, save: str,
                            output: str) -> str:
        """
        Formats the user inputs into a correct bash command
        :param pipeline: custom meshroom pipeline
        :param meshroom_batch: meshroom_batch.exe file to run
        :param images: images path folder
        :param to_node: the node to which to compile
        :param save: save path
        :param output: output path
        :return:
        """
        ## Make BASH command
        command = f"{meshroom_batch} --input {images} --pipeline {pipeline} --toNode {to_node} --save {save} --output {output}"

        return command

    def make_bash_command(self, data: dict) -> str:
        ## Test if inputs are valid in get parameters
        # if not self.test_if_inputs_valid(data):
        #     return ""

        pipeline = check_custom_pipeline_valid(data["custom_pipeline"])

        name = os.path.basename(data["image_dir"])  ## get name based on input folder name
        save_dir = os.path.join(data["work_dir"], name)
        meshroom_batch = os.path.join(data["meshroom_dir"], "meshroom_batch")

        to_node = data["to_node"]
        image_dir = data["image_dir"]
        output_dir = data["output_dir"]

        command = self.format_bash_command(meshroom_batch, image_dir, pipeline, to_node, save_dir, output_dir)

        return command

    def get_parameters(self):
        self.data["meshroom_dir"] = self.line_meshroom_dir.text()
        self.data["blender_dir"] = self.line_blender_dir.text()
        self.data["work_dir"] = self.line_work_dir.text()
        self.data["image_dir"] = self.line_image_dir.text()
        self.data["output_dir"] = self.line_output_dir.text()
        self.data["custom_pipeline"] = self.line_pipeline.text()
        self.data["to_node"] = self.line_to_node.text()

        self.enable_start_btn()

    def set_parameters(self):
        self.line_meshroom_dir.setText(str(self.data["meshroom_dir"]))
        self.line_blender_dir.setText(str(self.data["blender_dir"]))
        self.line_work_dir.setText(str(self.data["work_dir"]))
        self.line_image_dir.setText(str(self.data["image_dir"]))
        self.line_output_dir.setText(str(self.data["output_dir"]))
        self.line_to_node.setText(str(self.data["to_node"]))

    def enable_start_btn(self):
        if self.test_if_inputs_valid(self.data):
            self.button_start.setEnabled(True)
        else:
            self.button_start.setEnabled(False)

    def start(self):
        # self.get_parameters()
        command = self.make_bash_command(self.data)
        if command == "":
            print("Wrong data provided")
        else:
            print(command)

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

        ## TEMP
        # self.button_start.setEnabled(True)

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
        self.enable_start_btn()
        self.set_parameters()

    def filter_data(self, data: dict) -> dict:
        filtered_data = {
            "meshroom_dir": data.get("meshroom_dir"),
            "blender_dir": data.get("blender_dir"),
            "image_dir": data.get("image_dir"),
            "work_dir": data.get("work_dir"),
            "custom_pipeline": data.get("custom_pipeline"),
            "output_dir": data.get("output_dir"),
            "to_node": data.get("to_node")
        }
        return filtered_data

    def output_log(self):
        pass


def main():
    app = QApplication([])

    window = ProcessorGUI()
    app.exec_()


if __name__ == '__main__':
    # print("Command:", command)
    main()
