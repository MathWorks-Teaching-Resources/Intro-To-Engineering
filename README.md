
# <span style="color:rgb(213,80,0)">Introduction to Engineering: </span>

# <span style="color:rgb(213,80,0)">A Hands\-On Exploration with Arduino</span>


[![View on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/156477-introduction-to-engineering-with-arduino) or [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=README.mlx)

[![MATLAB Versions Tested](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2FMathWorks-Teaching-Resources%2FIntro-To-Engineering%2Frelease%2FImages%2FTestedWith.json)](https://MathWorks-Teaching-Resources.github.io/Intro-To-Engineering)

**Curriculum Module**

_Created with R2024a. Compatible with R2024a and later releases._

# Information

This curriculum module contains interactive [MATLAB® live scripts](https://www.mathworks.com/products/matlab/live-editor.html) introducing fundamental concepts of modern engineering using Arduino Hardware. The whole module is designed to explore these concepts using hardware using Arduino. You will explore the signals, data analysis, sensing, control and Internet of Things (IoT).


## Background

You can use these live scripts as demonstrations in lectures, class activities, or interactive assignments outside class. This module covers the concepts of signals, control, and technical writing. It also includes examples of the Internet of Things and physical modeling.


The instructions inside the live scripts will guide you through the exercises and activities. Get started with each live script by running it one section at a time. To stop running the script or a section midway (for example, when an animation is in progress), use the <img src="Images/image_0.png" width="19" alt="image_0.png"> Stop button in the **RUN** section of the **Live Editor** tab in the MATLAB Toolstrip.

## Contact Us

Solutions are available upon instructor request. Contact the [MathWorks teaching resources team](mailto:onlineteaching@mathworks.com) if you would like to request solutions, provide feedback, or if you have a question.


## Prerequisites

These scripts assume no prior knowledge of hardware programming and wiring. There is minimal MATLAB & Simulink knowledge required to complete the module. It is highly encouraged to follow online self\-paced training to complete most of the activities:

-  [MATLAB Onramp](https://matlabacademy.mathworks.com/details/matlab-onramp/gettingstarted) 
-  [Simulink Onramp](https://matlabacademy.mathworks.com/details/simulink-onramp/simulink) 
-  [Stateflow Onramp](https://matlabacademy.mathworks.com/details/stateflow-onramp/stateflow) 

## Getting Started

Download this repository. Open MATLAB, navigate to the folder containing these scripts, and double\-click on [intro\-to\-engineering.prj](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=README.mlx). It will add the appropriate files to your MATLAB path and open an app that asks you where you would like to start. 


To clone this repository, you can copy and paste the following command directly into your MATLAB Command Window:

<pre>
gitclone("https://github.com/MathWorks-Teaching-Resources/Intro-To-Engineering.git")
</pre>

Ensure you have all the required products (listed below) installed. If you need to include a product, add it using the Add\-On Explorer. To install an add\-on, go to the **Home** tab and select  <img src="Images/image_1.png" width="16" alt="image_1.png"> **Add-Ons** > **Get Add-Ons**. 


## Products

MATLAB®, Simulink®, Stateflow™, Symbolic Math Toolbox™, MATLAB Support package for Arduino, Simulink Support package for Arduino.

# Scripts
## [**SupportArduino.mlx**](./https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=Scripts/SupportArduino.mlx)
|      |      |
| :-- | :-- |
| <img src="Images/image_2.png" width="171" alt="image_2.png"> <br>  | **In this script, students will...** <br> $\bullet$ Check their Arduino board compatibility. <br> $\bullet$ Install MATLAB and Simulink support packages for Arduino Hardware. <br> $\bullet$ Setup ThingSpeak channel for IoT. <br>   |
|      |       |

## [BlinkToSOS.mlx](./https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=Scripts/BlinkToSOS.mlx)
|      |      |
| :-- | :-- |
| <img src="Images/image_3.png" width="171" alt="image_3.png"> <br>  | **In this script, students will...** <br> $\bullet$ Learn the fundamental type of signals supported on and Arduino board. <br> $\bullet$ Wire a simple LED to their Arduino board. <br> $\bullet$ Control the LED from a simple blink to encoding Morse code. <br>   |
|      |       |

## [**ReactionAnalyzer.mlx**](./https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=Scripts/ReactionAnalyzer.mlx)
|      |      |
| :-- | :-- |
| <img src="Images/image_4.png" width="171" alt="image_4.png"> <br>  | **In this script, students will...** <br> $\bullet$ Learn how to control Arduino with a Stateflow diagram. <br> $\bullet$ Learn data analysis techniques. <br> $\bullet$ Write and export experiment report from MATLAB. <br>   |
|      |       |

## [**GreenhouseControl.mlx**](./https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=Scripts/GreenhouseControl.mlx)
|      |      |
| :-- | :-- |
| <img src="Images/image_5.png" width="171" alt="image_5.png"> <br>  | **In this script, students will...** <br> $\bullet$ Use a temperature sensor. <br> $\bullet$ Develop a control algorithm. <br> $\bullet$ Test their control algorithm. <br>   |
|      |       |

## [**GreenhouseModel.mlx**](./https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=Scripts/GreenhouseModel.mlx)
|      |      |
| :-- | :-- |
| <img src="Images/image_6.png" width="171" alt="image_6.png"> <br>  | **In this script, students will...** <br> $\bullet$ Use a Simscape thermal model. <br> $\bullet$ Simulate the greenhouse over a full year of data. <br> $\bullet$ Test multiple fans to validate the design. <br>   |
|      |       |

## [**ConnectedGreenhouse.mlx**](./https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=Scripts/ConnectedGreenhouse.mlx)
|      |      |
| :-- | :-- |
| <img src="Images/image_7.png" width="171" alt="image_7.png"> <br>  | **In this script, students will...** <br> $\bullet$ Learn how to read and write from a ThingSpeak channel. <br> $\bullet$ Log the temperature in the greenhouse on their own channel. <br> $\bullet$ Create an alert when the temperature exceeds the acceptable range. <br>   |
|      |       |

# Related Courseware Modules
## [**Robotic Manipulators**](https://www.mathworks.com/matlabcentral/fileexchange/130124-robotic-manipulators) 
|      |      |
| :-- | :-- |
| <img src="Images/image_8.png" width="171" alt="image_8.png"> <br>  | **Available on:** <br> [<img src="Images/image_9.png" width="129" alt="image_9.png">](https://www.mathworks.com/matlabcentral/fileexchange/130124-robotic-manipulators)  <br> [<img src="Images/image_10.png" width="156" alt="image_10.png">](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Robotic-Manipulators&project=Robotic-Manipulators.prj) <br> [GitHub](https://github.com/MathWorks-Teaching-Resources/Robotic-Manipulators) <br>   |
|      |       |


Or feel free to explore our other [modular courseware content](https://www.mathworks.com/matlabcentral/fileexchange/?q=tag%3A%22courseware+module%22&sort=downloads_desc_30d).

# Educator Resources
-  [Educator Page](https://www.mathworks.com/academia/educators.html) 

# Contribute 

Looking for more? Find an issue? Have a suggestion? Please contact the [MathWorks teaching resources team](mailto:%20onlineteaching@mathworks.com). If you want to contribute directly to this project, you can find information about how to do so in the [CONTRIBUTING.md](https://github.com/MathWorks-Teaching-Resources/Intro-To-Engineering/blob/release/CONTRIBUTING.md) page on GitHub.


Copyright 2023 The MathWorks™, Inc


