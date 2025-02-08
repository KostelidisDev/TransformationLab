# TransformationLab
This MATLAB project contains a script that performs geometric image transformations (scale, rotation, scale and rotations), feature extraction and estimation of those geometric tranformations using KAZE and ORB methods.

# Description
This work focuses on the development of a script, called “TransformationLab”, which, through
predefined geometric transformations (scaling, rotation, scaling and rotation) on a digital image,
aims to evaluate the accuracy of the transformation estimation through the KAZE and ORB feature
detection methods. In detail, the steps it performs:
* Image pre-processing: The input image is loaded and converted into a grayscale image.
    * Feature extraction: The feature points with the KAZE and ORB method of the grayscale
    image.
    * Application of transformations: A set of scaling, rotation and combinations of these
    transformations is applied to the grayscale image.
    * Feature extraction: The feature points with the KAZE and ORB method of the
    transformed image.
    * Feature matching and estimation: Matching the features of the grayscale image with
    the features of the transformed image and estimating the transformation.
    * Error analysis: The estimated values are compared with the actual transformations
    and the error difference is calculated.
* Result display: Display the results in the terminal (command window) and as a window
(figure).


# Extra files
** The extra files are written in Greek Language.
* [PDF/Text](./assets/Ρ104%20-%20TransformationLab.pdf)

# License

[MIT License](./LICENSE)

# Atrributes
The Demo.jpg image is from [Pixabay.com](https://pixabay.com/photos/chrysanthemum-flowers-plant-7707028/)

# Disclaimer

This project was conducted as part of the course Ρ104: Robotic Vision in the M.Sc. program in Robotics, offered by the
Department of Computer, Informatics and Telecommunications Engineering at the International Hellenic University.