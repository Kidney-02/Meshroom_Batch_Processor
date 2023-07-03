{
    "header": {
        "pipelineVersion": "2.2",
        "releaseVersion": "2023.2.0",
        "fileVersion": "1.1",
        "template": true,
        "nodesVersions": {
            "FeatureExtraction": "1.2",
            "Meshing": "7.0",
            "PrepareDenseScene": "3.0",
            "CameraInit": "9.0",
            "FeatureMatching": "2.0",
            "ImageMatching": "2.0",
            "DepthMapFilter": "3.0",
            "SfMTransform": "3.1",
            "MeshResampling": "1.0",
            "StructureFromMotion": "3.1",
            "MeshFiltering": "3.0",
            "Texturing": "6.0",
            "DepthMap": "4.0"
        }
    },
    "graph": {
        "Texturing_1": {
            "nodeType": "Texturing",
            "position": [
                2111,
                121
            ],
            "inputs": {
                "input": "{Meshing_1.output}",
                "imagesFolder": "{DepthMap_1.imagesFolder}",
                "inputMesh": "{MeshResampling_1.output}",
                "textureSide": 2048,
                "colorMapping": {
                    "enable": true,
                    "colorMappingFileType": "png"
                }
            }
        },
        "Meshing_1": {
            "nodeType": "Meshing",
            "position": [
                1507,
                10
            ],
            "inputs": {
                "input": "{DepthMapFilter_1.input}",
                "depthMapsFolder": "{DepthMapFilter_1.output}"
            }
        },
        "DepthMapFilter_1": {
            "nodeType": "DepthMapFilter",
            "position": [
                1307,
                10
            ],
            "inputs": {
                "input": "{DepthMap_1.input}",
                "depthMapsFolder": "{DepthMap_1.output}"
            }
        },
        "ImageMatching_1": {
            "nodeType": "ImageMatching",
            "position": [
                -37,
                -7
            ],
            "inputs": {
                "input": "{FeatureExtraction_1.input}",
                "featuresFolders": [
                    "{FeatureExtraction_1.output}"
                ]
            }
        },
        "FeatureExtraction_1": {
            "nodeType": "FeatureExtraction",
            "position": [
                -237,
                -7
            ],
            "inputs": {
                "input": "{CameraInit_1.output}"
            }
        },
        "StructureFromMotion_1": {
            "nodeType": "StructureFromMotion",
            "position": [
                363,
                -7
            ],
            "inputs": {
                "input": "{FeatureMatching_1.input}",
                "featuresFolders": "{FeatureMatching_1.featuresFolders}",
                "matchesFolders": [
                    "{FeatureMatching_1.output}"
                ],
                "describerTypes": "{FeatureMatching_1.describerTypes}"
            }
        },
        "PrepareDenseScene_1": {
            "nodeType": "PrepareDenseScene",
            "position": [
                907,
                10
            ],
            "inputs": {
                "input": "{SfMTransform_1.output}"
            }
        },
        "CameraInit_1": {
            "nodeType": "CameraInit",
            "position": [
                -437,
                -7
            ],
            "inputs": {
                "viewpoints": [
                    {
                        "viewId": 46849609,
                        "poseId": 46849609,
                        "path": "C:/Users/kidne/OneDrive/Documents/Meshroom/Meshroom/dataset_monstree-master/mini6/IMG_1028.JPG",
                        "intrinsicId": 960434615,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"4.890000\", \"DateTime\": \"2017:07:18 15:31:37\", \"Exif:ApertureValue\": \"1.69599\", \"Exif:BrightnessValue\": \"4.88065\", \"Exif:ColorSpace\": \"65535\", \"Exif:CustomRendered\": \"2\", \"Exif:DateTimeDigitized\": \"2017:07:18 15:31:37\", \"Exif:DateTimeOriginal\": \"2017:07:18 15:31:37\", \"Exif:ExifVersion\": \"0221\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"2\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"3.99\", \"Exif:FocalLengthIn35mmFilm\": \"28\", \"Exif:LensMake\": \"Apple\", \"Exif:LensModel\": \"iPhone 7 back camera 3.99mm f/1.8\", \"Exif:LensSpecification\": \"3.99, 3.99, 1.8, 1.8\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"25\", \"Exif:PixelXDimension\": \"4032\", \"Exif:PixelYDimension\": \"3024\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:ShutterSpeedValue\": \"5.90695\", \"Exif:SubsecTimeDigitized\": \"070\", \"Exif:SubsecTimeOriginal\": \"070\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"1\", \"ExposureTime\": \"0.0166667\", \"FNumber\": \"1.8\", \"GPS:Altitude\": \"1224.76\", \"GPS:AltitudeRef\": \"0\", \"GPS:DateStamp\": \"2017:07:18\", \"GPS:DestBearing\": \"321.639\", \"GPS:DestBearingRef\": \"T\", \"GPS:HPositioningError\": \"12\", \"GPS:ImgDirection\": \"321.639\", \"GPS:ImgDirectionRef\": \"T\", \"GPS:Latitude\": \"37, 43, 23.86\", \"GPS:LatitudeRef\": \"N\", \"GPS:Longitude\": \"119, 36, 57.37\", \"GPS:LongitudeRef\": \"W\", \"GPS:Speed\": \"0.178955\", \"GPS:SpeedRef\": \"K\", \"GPS:TimeStamp\": \"22, 31, 36\", \"ICCProfile\": \"0, 0, 2, 36, 97, 112, 112, 108, 4, 0, 0, 0, 109, 110, 116, 114, 82, 71, 66, 32, 88, 89, 90, 32, 7, 223, 0, 10, 0, 14, 0, 13, 0, 8, 0, 57, 97, 99, 115, 112, 65, 80, 80, 76, 0, 0, 0, 0, 65, 80, 80, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ... [548 x uint8]\", \"ICCProfile:attributes\": \"Reflective, Glossy, Positive, Color\", \"ICCProfile:cmm_type\": \"1634758764\", \"ICCProfile:color_space\": \"RGB\", \"ICCProfile:copyright\": \"Copyright Apple Inc., 2015\", \"ICCProfile:creation_date\": \"2015:10:14 13:08:57\", \"ICCProfile:creator_signature\": \"6170706c\", \"ICCProfile:device_class\": \"Display device profile\", \"ICCProfile:flags\": \"Not Embedded, Independent\", \"ICCProfile:manufacturer\": \"4150504c\", \"ICCProfile:model\": \"0\", \"ICCProfile:platform_signature\": \"Apple Computer, Inc.\", \"ICCProfile:profile_connection_space\": \"XYZ\", \"ICCProfile:profile_description\": \"Display P3\", \"ICCProfile:profile_size\": \"548\", \"ICCProfile:profile_version\": \"4.0.0\", \"ICCProfile:rendering_intent\": \"Perceptual\", \"Make\": \"Apple\", \"Model\": \"iPhone 7\", \"Orientation\": \"6\", \"ResolutionUnit\": \"none\", \"Software\": \"10.3.2\", \"XResolution\": \"72\", \"YResolution\": \"72\", \"jpeg:subsampling\": \"4:2:0\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 709119907,
                        "poseId": 709119907,
                        "path": "C:/Users/kidne/OneDrive/Documents/Meshroom/Meshroom/dataset_monstree-master/mini6/IMG_1024.JPG",
                        "intrinsicId": 960434615,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"4.890000\", \"DateTime\": \"2017:07:18 15:31:28\", \"Exif:ApertureValue\": \"1.69599\", \"Exif:BrightnessValue\": \"5.17327\", \"Exif:ColorSpace\": \"65535\", \"Exif:DateTimeDigitized\": \"2017:07:18 15:31:28\", \"Exif:DateTimeOriginal\": \"2017:07:18 15:31:28\", \"Exif:ExifVersion\": \"0221\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"2\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"3.99\", \"Exif:FocalLengthIn35mmFilm\": \"28\", \"Exif:LensMake\": \"Apple\", \"Exif:LensModel\": \"iPhone 7 back camera 3.99mm f/1.8\", \"Exif:LensSpecification\": \"3.99, 3.99, 1.8, 1.8\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"40\", \"Exif:PixelXDimension\": \"4032\", \"Exif:PixelYDimension\": \"3024\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:ShutterSpeedValue\": \"6.90799\", \"Exif:SubsecTimeDigitized\": \"462\", \"Exif:SubsecTimeOriginal\": \"462\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"1\", \"ExposureTime\": \"0.00833333\", \"FNumber\": \"1.8\", \"GPS:Altitude\": \"1224.42\", \"GPS:AltitudeRef\": \"0\", \"GPS:DateStamp\": \"2017:07:18\", \"GPS:DestBearing\": \"7.97446\", \"GPS:DestBearingRef\": \"T\", \"GPS:HPositioningError\": \"8\", \"GPS:ImgDirection\": \"7.97446\", \"GPS:ImgDirectionRef\": \"T\", \"GPS:Latitude\": \"37, 43, 23.86\", \"GPS:LatitudeRef\": \"N\", \"GPS:Longitude\": \"119, 36, 57.18\", \"GPS:LongitudeRef\": \"W\", \"GPS:Speed\": \"0.0605214\", \"GPS:SpeedRef\": \"K\", \"GPS:TimeStamp\": \"22, 31, 28\", \"ICCProfile\": \"0, 0, 2, 36, 97, 112, 112, 108, 4, 0, 0, 0, 109, 110, 116, 114, 82, 71, 66, 32, 88, 89, 90, 32, 7, 223, 0, 10, 0, 14, 0, 13, 0, 8, 0, 57, 97, 99, 115, 112, 65, 80, 80, 76, 0, 0, 0, 0, 65, 80, 80, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ... [548 x uint8]\", \"ICCProfile:attributes\": \"Reflective, Glossy, Positive, Color\", \"ICCProfile:cmm_type\": \"1634758764\", \"ICCProfile:color_space\": \"RGB\", \"ICCProfile:copyright\": \"Copyright Apple Inc., 2015\", \"ICCProfile:creation_date\": \"2015:10:14 13:08:57\", \"ICCProfile:creator_signature\": \"6170706c\", \"ICCProfile:device_class\": \"Display device profile\", \"ICCProfile:flags\": \"Not Embedded, Independent\", \"ICCProfile:manufacturer\": \"4150504c\", \"ICCProfile:model\": \"0\", \"ICCProfile:platform_signature\": \"Apple Computer, Inc.\", \"ICCProfile:profile_connection_space\": \"XYZ\", \"ICCProfile:profile_description\": \"Display P3\", \"ICCProfile:profile_size\": \"548\", \"ICCProfile:profile_version\": \"4.0.0\", \"ICCProfile:rendering_intent\": \"Perceptual\", \"Make\": \"Apple\", \"Model\": \"iPhone 7\", \"Orientation\": \"6\", \"ResolutionUnit\": \"none\", \"Software\": \"10.3.2\", \"XResolution\": \"72\", \"YResolution\": \"72\", \"jpeg:subsampling\": \"4:2:0\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 993838148,
                        "poseId": 993838148,
                        "path": "C:/Users/kidne/OneDrive/Documents/Meshroom/Meshroom/dataset_monstree-master/mini6/IMG_1026.JPG",
                        "intrinsicId": 960434615,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"4.890000\", \"DateTime\": \"2017:07:18 15:31:32\", \"Exif:ApertureValue\": \"1.69599\", \"Exif:BrightnessValue\": \"5.00969\", \"Exif:ColorSpace\": \"65535\", \"Exif:CustomRendered\": \"2\", \"Exif:DateTimeDigitized\": \"2017:07:18 15:31:32\", \"Exif:DateTimeOriginal\": \"2017:07:18 15:31:32\", \"Exif:ExifVersion\": \"0221\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"2\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"3.99\", \"Exif:FocalLengthIn35mmFilm\": \"28\", \"Exif:LensMake\": \"Apple\", \"Exif:LensModel\": \"iPhone 7 back camera 3.99mm f/1.8\", \"Exif:LensSpecification\": \"3.99, 3.99, 1.8, 1.8\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"25\", \"Exif:PixelXDimension\": \"4032\", \"Exif:PixelYDimension\": \"3024\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:ShutterSpeedValue\": \"5.90695\", \"Exif:SubsecTimeDigitized\": \"966\", \"Exif:SubsecTimeOriginal\": \"966\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"1\", \"ExposureTime\": \"0.0166667\", \"FNumber\": \"1.8\", \"GPS:Altitude\": \"1224.68\", \"GPS:AltitudeRef\": \"0\", \"GPS:DateStamp\": \"2017:07:18\", \"GPS:DestBearing\": \"346.362\", \"GPS:DestBearingRef\": \"T\", \"GPS:HPositioningError\": \"8\", \"GPS:ImgDirection\": \"346.362\", \"GPS:ImgDirectionRef\": \"T\", \"GPS:Latitude\": \"37, 43, 23.81\", \"GPS:LatitudeRef\": \"N\", \"GPS:Longitude\": \"119, 36, 57.29\", \"GPS:LongitudeRef\": \"W\", \"GPS:Speed\": \"0.188065\", \"GPS:SpeedRef\": \"K\", \"GPS:TimeStamp\": \"22, 31, 32\", \"ICCProfile\": \"0, 0, 2, 36, 97, 112, 112, 108, 4, 0, 0, 0, 109, 110, 116, 114, 82, 71, 66, 32, 88, 89, 90, 32, 7, 223, 0, 10, 0, 14, 0, 13, 0, 8, 0, 57, 97, 99, 115, 112, 65, 80, 80, 76, 0, 0, 0, 0, 65, 80, 80, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ... [548 x uint8]\", \"ICCProfile:attributes\": \"Reflective, Glossy, Positive, Color\", \"ICCProfile:cmm_type\": \"1634758764\", \"ICCProfile:color_space\": \"RGB\", \"ICCProfile:copyright\": \"Copyright Apple Inc., 2015\", \"ICCProfile:creation_date\": \"2015:10:14 13:08:57\", \"ICCProfile:creator_signature\": \"6170706c\", \"ICCProfile:device_class\": \"Display device profile\", \"ICCProfile:flags\": \"Not Embedded, Independent\", \"ICCProfile:manufacturer\": \"4150504c\", \"ICCProfile:model\": \"0\", \"ICCProfile:platform_signature\": \"Apple Computer, Inc.\", \"ICCProfile:profile_connection_space\": \"XYZ\", \"ICCProfile:profile_description\": \"Display P3\", \"ICCProfile:profile_size\": \"548\", \"ICCProfile:profile_version\": \"4.0.0\", \"ICCProfile:rendering_intent\": \"Perceptual\", \"Make\": \"Apple\", \"Model\": \"iPhone 7\", \"Orientation\": \"6\", \"ResolutionUnit\": \"none\", \"Software\": \"10.3.2\", \"XResolution\": \"72\", \"YResolution\": \"72\", \"jpeg:subsampling\": \"4:2:0\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 1552112064,
                        "poseId": 1552112064,
                        "path": "C:/Users/kidne/OneDrive/Documents/Meshroom/Meshroom/dataset_monstree-master/mini6/IMG_1040.JPG",
                        "intrinsicId": 960434615,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"4.890000\", \"DateTime\": \"2017:07:18 15:32:07\", \"Exif:ApertureValue\": \"1.69599\", \"Exif:BrightnessValue\": \"5.27233\", \"Exif:ColorSpace\": \"65535\", \"Exif:DateTimeDigitized\": \"2017:07:18 15:32:07\", \"Exif:DateTimeOriginal\": \"2017:07:18 15:32:07\", \"Exif:ExifVersion\": \"0221\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"2\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"3.99\", \"Exif:FocalLengthIn35mmFilm\": \"28\", \"Exif:LensMake\": \"Apple\", \"Exif:LensModel\": \"iPhone 7 back camera 3.99mm f/1.8\", \"Exif:LensSpecification\": \"3.99, 3.99, 1.8, 1.8\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"40\", \"Exif:PixelXDimension\": \"4032\", \"Exif:PixelYDimension\": \"3024\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:ShutterSpeedValue\": \"6.90799\", \"Exif:SubsecTimeDigitized\": \"397\", \"Exif:SubsecTimeOriginal\": \"397\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"1\", \"ExposureTime\": \"0.00833333\", \"FNumber\": \"1.8\", \"GPS:Altitude\": \"1225.15\", \"GPS:AltitudeRef\": \"0\", \"GPS:DateStamp\": \"2017:07:18\", \"GPS:DestBearing\": \"296.664\", \"GPS:DestBearingRef\": \"T\", \"GPS:HPositioningError\": \"16\", \"GPS:ImgDirection\": \"296.664\", \"GPS:ImgDirectionRef\": \"T\", \"GPS:Latitude\": \"37, 43, 23.87\", \"GPS:LatitudeRef\": \"N\", \"GPS:Longitude\": \"119, 36, 57.54\", \"GPS:LongitudeRef\": \"W\", \"GPS:Speed\": \"0.00208859\", \"GPS:SpeedRef\": \"K\", \"GPS:TimeStamp\": \"22, 32, 7\", \"ICCProfile\": \"0, 0, 2, 36, 97, 112, 112, 108, 4, 0, 0, 0, 109, 110, 116, 114, 82, 71, 66, 32, 88, 89, 90, 32, 7, 223, 0, 10, 0, 14, 0, 13, 0, 8, 0, 57, 97, 99, 115, 112, 65, 80, 80, 76, 0, 0, 0, 0, 65, 80, 80, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ... [548 x uint8]\", \"ICCProfile:attributes\": \"Reflective, Glossy, Positive, Color\", \"ICCProfile:cmm_type\": \"1634758764\", \"ICCProfile:color_space\": \"RGB\", \"ICCProfile:copyright\": \"Copyright Apple Inc., 2015\", \"ICCProfile:creation_date\": \"2015:10:14 13:08:57\", \"ICCProfile:creator_signature\": \"6170706c\", \"ICCProfile:device_class\": \"Display device profile\", \"ICCProfile:flags\": \"Not Embedded, Independent\", \"ICCProfile:manufacturer\": \"4150504c\", \"ICCProfile:model\": \"0\", \"ICCProfile:platform_signature\": \"Apple Computer, Inc.\", \"ICCProfile:profile_connection_space\": \"XYZ\", \"ICCProfile:profile_description\": \"Display P3\", \"ICCProfile:profile_size\": \"548\", \"ICCProfile:profile_version\": \"4.0.0\", \"ICCProfile:rendering_intent\": \"Perceptual\", \"Make\": \"Apple\", \"Model\": \"iPhone 7\", \"Orientation\": \"6\", \"ResolutionUnit\": \"none\", \"Software\": \"10.3.2\", \"XResolution\": \"72\", \"YResolution\": \"72\", \"jpeg:subsampling\": \"4:2:0\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 1908548776,
                        "poseId": 1908548776,
                        "path": "C:/Users/kidne/OneDrive/Documents/Meshroom/Meshroom/dataset_monstree-master/mini6/IMG_1032.JPG",
                        "intrinsicId": 960434615,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"4.890000\", \"DateTime\": \"2017:07:18 15:31:43\", \"Exif:ApertureValue\": \"1.69599\", \"Exif:BrightnessValue\": \"5.30845\", \"Exif:ColorSpace\": \"65535\", \"Exif:DateTimeDigitized\": \"2017:07:18 15:31:43\", \"Exif:DateTimeOriginal\": \"2017:07:18 15:31:43\", \"Exif:ExifVersion\": \"0221\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"2\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"3.99\", \"Exif:FocalLengthIn35mmFilm\": \"28\", \"Exif:LensMake\": \"Apple\", \"Exif:LensModel\": \"iPhone 7 back camera 3.99mm f/1.8\", \"Exif:LensSpecification\": \"3.99, 3.99, 1.8, 1.8\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"40\", \"Exif:PixelXDimension\": \"4032\", \"Exif:PixelYDimension\": \"3024\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:ShutterSpeedValue\": \"6.90799\", \"Exif:SubsecTimeDigitized\": \"375\", \"Exif:SubsecTimeOriginal\": \"375\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"1\", \"ExposureTime\": \"0.00833333\", \"FNumber\": \"1.8\", \"GPS:Altitude\": \"1225.62\", \"GPS:AltitudeRef\": \"0\", \"GPS:DateStamp\": \"2017:07:18\", \"GPS:DestBearing\": \"280.988\", \"GPS:DestBearingRef\": \"T\", \"GPS:HPositioningError\": \"8\", \"GPS:ImgDirection\": \"280.988\", \"GPS:ImgDirectionRef\": \"T\", \"GPS:Latitude\": \"37, 43, 23.84\", \"GPS:LatitudeRef\": \"N\", \"GPS:Longitude\": \"119, 36, 57.43\", \"GPS:LongitudeRef\": \"W\", \"GPS:Speed\": \"0.0628009\", \"GPS:SpeedRef\": \"K\", \"GPS:TimeStamp\": \"22, 31, 43\", \"ICCProfile\": \"0, 0, 2, 36, 97, 112, 112, 108, 4, 0, 0, 0, 109, 110, 116, 114, 82, 71, 66, 32, 88, 89, 90, 32, 7, 223, 0, 10, 0, 14, 0, 13, 0, 8, 0, 57, 97, 99, 115, 112, 65, 80, 80, 76, 0, 0, 0, 0, 65, 80, 80, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ... [548 x uint8]\", \"ICCProfile:attributes\": \"Reflective, Glossy, Positive, Color\", \"ICCProfile:cmm_type\": \"1634758764\", \"ICCProfile:color_space\": \"RGB\", \"ICCProfile:copyright\": \"Copyright Apple Inc., 2015\", \"ICCProfile:creation_date\": \"2015:10:14 13:08:57\", \"ICCProfile:creator_signature\": \"6170706c\", \"ICCProfile:device_class\": \"Display device profile\", \"ICCProfile:flags\": \"Not Embedded, Independent\", \"ICCProfile:manufacturer\": \"4150504c\", \"ICCProfile:model\": \"0\", \"ICCProfile:platform_signature\": \"Apple Computer, Inc.\", \"ICCProfile:profile_connection_space\": \"XYZ\", \"ICCProfile:profile_description\": \"Display P3\", \"ICCProfile:profile_size\": \"548\", \"ICCProfile:profile_version\": \"4.0.0\", \"ICCProfile:rendering_intent\": \"Perceptual\", \"Make\": \"Apple\", \"Model\": \"iPhone 7\", \"Orientation\": \"6\", \"ResolutionUnit\": \"none\", \"Software\": \"10.3.2\", \"XResolution\": \"72\", \"YResolution\": \"72\", \"jpeg:subsampling\": \"4:2:0\", \"oiio:ColorSpace\": \"sRGB\"}"
                    },
                    {
                        "viewId": 2015987915,
                        "poseId": 2015987915,
                        "path": "C:/Users/kidne/OneDrive/Documents/Meshroom/Meshroom/dataset_monstree-master/mini6/IMG_1030.JPG",
                        "intrinsicId": 960434615,
                        "rigId": -1,
                        "subPoseId": -1,
                        "metadata": "{\"AliceVision:SensorWidth\": \"4.890000\", \"DateTime\": \"2017:07:18 15:31:40\", \"Exif:ApertureValue\": \"1.69599\", \"Exif:BrightnessValue\": \"5.13984\", \"Exif:ColorSpace\": \"65535\", \"Exif:DateTimeDigitized\": \"2017:07:18 15:31:40\", \"Exif:DateTimeOriginal\": \"2017:07:18 15:31:40\", \"Exif:ExifVersion\": \"0221\", \"Exif:ExposureBiasValue\": \"0\", \"Exif:ExposureMode\": \"0\", \"Exif:ExposureProgram\": \"2\", \"Exif:Flash\": \"24\", \"Exif:FlashPixVersion\": \"0100\", \"Exif:FocalLength\": \"3.99\", \"Exif:FocalLengthIn35mmFilm\": \"28\", \"Exif:LensMake\": \"Apple\", \"Exif:LensModel\": \"iPhone 7 back camera 3.99mm f/1.8\", \"Exif:LensSpecification\": \"3.99, 3.99, 1.8, 1.8\", \"Exif:MeteringMode\": \"5\", \"Exif:PhotographicSensitivity\": \"20\", \"Exif:PixelXDimension\": \"4032\", \"Exif:PixelYDimension\": \"3024\", \"Exif:SceneCaptureType\": \"0\", \"Exif:SensingMethod\": \"2\", \"Exif:ShutterSpeedValue\": \"5.90695\", \"Exif:SubsecTimeDigitized\": \"039\", \"Exif:SubsecTimeOriginal\": \"039\", \"Exif:WhiteBalance\": \"0\", \"Exif:YCbCrPositioning\": \"1\", \"ExposureTime\": \"0.0166667\", \"FNumber\": \"1.8\", \"GPS:Altitude\": \"1226.57\", \"GPS:AltitudeRef\": \"0\", \"GPS:DateStamp\": \"2017:07:18\", \"GPS:DestBearing\": \"292.657\", \"GPS:DestBearingRef\": \"T\", \"GPS:HPositioningError\": \"12\", \"GPS:ImgDirection\": \"292.657\", \"GPS:ImgDirectionRef\": \"T\", \"GPS:Latitude\": \"37, 43, 23.87\", \"GPS:LatitudeRef\": \"N\", \"GPS:Longitude\": \"119, 36, 57.43\", \"GPS:LongitudeRef\": \"W\", \"GPS:Speed\": \"0.321036\", \"GPS:SpeedRef\": \"K\", \"GPS:TimeStamp\": \"22, 31, 39\", \"ICCProfile\": \"0, 0, 2, 36, 97, 112, 112, 108, 4, 0, 0, 0, 109, 110, 116, 114, 82, 71, 66, 32, 88, 89, 90, 32, 7, 223, 0, 10, 0, 14, 0, 13, 0, 8, 0, 57, 97, 99, 115, 112, 65, 80, 80, 76, 0, 0, 0, 0, 65, 80, 80, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ... [548 x uint8]\", \"ICCProfile:attributes\": \"Reflective, Glossy, Positive, Color\", \"ICCProfile:cmm_type\": \"1634758764\", \"ICCProfile:color_space\": \"RGB\", \"ICCProfile:copyright\": \"Copyright Apple Inc., 2015\", \"ICCProfile:creation_date\": \"2015:10:14 13:08:57\", \"ICCProfile:creator_signature\": \"6170706c\", \"ICCProfile:device_class\": \"Display device profile\", \"ICCProfile:flags\": \"Not Embedded, Independent\", \"ICCProfile:manufacturer\": \"4150504c\", \"ICCProfile:model\": \"0\", \"ICCProfile:platform_signature\": \"Apple Computer, Inc.\", \"ICCProfile:profile_connection_space\": \"XYZ\", \"ICCProfile:profile_description\": \"Display P3\", \"ICCProfile:profile_size\": \"548\", \"ICCProfile:profile_version\": \"4.0.0\", \"ICCProfile:rendering_intent\": \"Perceptual\", \"Make\": \"Apple\", \"Model\": \"iPhone 7\", \"Orientation\": \"6\", \"ResolutionUnit\": \"none\", \"Software\": \"10.3.2\", \"XResolution\": \"72\", \"YResolution\": \"72\", \"jpeg:subsampling\": \"4:2:0\", \"oiio:ColorSpace\": \"sRGB\"}"
                    }
                ],
                "intrinsics": [
                    {
                        "intrinsicId": 960434615,
                        "initialFocalLength": 3.99,
                        "focalLength": 3.99,
                        "pixelRatio": 1.0,
                        "pixelRatioLocked": true,
                        "type": "radial3",
                        "width": 4032,
                        "height": 3024,
                        "sensorWidth": 4.89,
                        "sensorHeight": 3.6675,
                        "serialNumber": "C:\\Users\\kidne\\OneDrive\\Documents\\Meshroom\\Meshroom\\dataset_monstree-master\\mini6_Apple_iPhone 7",
                        "principalPoint": {
                            "x": 0.0,
                            "y": 0.0
                        },
                        "initializationMode": "estimated",
                        "distortionInitializationMode": "none",
                        "distortionParams": [
                            0.0,
                            0.0,
                            0.0
                        ],
                        "undistortionOffset": {
                            "x": 0.0,
                            "y": 0.0
                        },
                        "undistortionParams": [],
                        "locked": false
                    }
                ]
            }
        },
        "DepthMap_1": {
            "nodeType": "DepthMap",
            "position": [
                1107,
                10
            ],
            "inputs": {
                "input": "{PrepareDenseScene_1.input}",
                "imagesFolder": "{PrepareDenseScene_1.output}"
            }
        },
        "MeshFiltering_1": {
            "nodeType": "MeshFiltering",
            "position": [
                1707,
                10
            ],
            "inputs": {
                "inputMesh": "{Meshing_1.outputMesh}",
                "keepLargestMeshOnly": true,
                "smoothingIterations": 0,
                "filterLargeTrianglesFactor": 40.0
            }
        },
        "FeatureMatching_1": {
            "nodeType": "FeatureMatching",
            "position": [
                163,
                -7
            ],
            "inputs": {
                "input": "{ImageMatching_1.input}",
                "featuresFolders": "{ImageMatching_1.featuresFolders}",
                "imagePairsList": "{ImageMatching_1.output}",
                "describerTypes": "{FeatureExtraction_1.describerTypes}"
            }
        },
        "SfMTransform_1": {
            "nodeType": "SfMTransform",
            "position": [
                577,
                -19
            ],
            "inputs": {
                "input": "{StructureFromMotion_1.output}",
                "method": "auto_from_cameras_x_axis",
                "landmarksDescriberTypes": [
                    "sift",
                    "dspsift",
                    "akaze",
                    "sift_upright",
                    "sift_float"
                ],
                "applyScale": false,
                "applyTranslation": false
            }
        },
        "MeshResampling_1": {
            "nodeType": "MeshResampling",
            "position": [
                1910,
                9
            ],
            "inputs": {
                "input": "{MeshFiltering_1.outputMesh}",
                "simplificationFactor": 0.91,
                "nbLloydIter": 1,
                "flipNormals": true
            }
        }
    }
}