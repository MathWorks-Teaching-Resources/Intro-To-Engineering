# <span style="color:rgb(213,80,0)">Introduction to Engineering: </span>
# <span style="color:rgb(213,80,0)">A Hands-On Exploration with Arduino</span>
<a name="H_053613DF"></a>

[![View on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/156477-introduction-to-engineering-with-arduino)

**Curriculum Module**

_Created with R2023b. Compatible with R2023b and later releases._

# Information

This curriculum module contains interactive [MATLAB® live scripts](https://www.mathworks.com/products/matlab/live-editor.html) introducing fundamental concepts of modern engineering using Arduino Hardware. The whole module is designed to explore these concepts using hardware using Arduino. You will explore the signals, data analysis, sensing, control and Internet of Things (IoT).

<a name="H_F00D98E4"></a>
## Background

You can use these live scripts as demonstrations in lectures, class activities, or interactive assignments outside class. This module covers the concepts of signals, control, and technical writing. It also includes examples of the Internet of Things and physical modeling.


The instructions inside the live scripts will guide you through the exercises and activities. Get started with each live script by running it one section at a time. To stop running the script or a section midway (for example, when an animation is in progress), use the <img src="Images/image_0.png" width="19" alt="image_0.png"> Stop button in the **RUN** section of the **Live Editor** tab in the MATLAB Toolstrip.

## Contact Us

Solutions are available upon instructor request. Contact the [MathWorks teaching resources team](mailto:onlineteaching@mathworks.com) if you would like to request solutions, provide feedback, or if you have a question.

<a name="H_30BC7141"></a>
## Prerequisites

These scripts assume no prior knowledge of hardware programming and wiring. There is minimal MATLAB & Simulink knowledge required to complete the module. It is highly encouraged to follow online self-paced training to complete most of the activities:

-  [MATLAB Onramp](https://matlabacademy.mathworks.com/details/matlab-onramp/gettingstarted) 
-  [Simulink Onramp](https://matlabacademy.mathworks.com/details/simulink-onramp/simulink) 
-  [Stateflow Onramp](https://matlabacademy.mathworks.com/details/stateflow-onramp/stateflow) 
<a name="H_330E72C3"></a>
## Getting Started

Download this repository. Open MATLAB, navigate to the folder containing these scripts, and double-click on [intro-to-engineering.prj](matlab: openProject("intro-to-engineering.prj")). It will add the appropriate files to your MATLAB path and open an app that asks you where you would like to start. 

To clone this repository, you can copy and paste the following command directly into your MATLAB Command Window:

<pre>
gitclone("https://github.com/MathWorks-Teaching-Resources/Intro-To-Engineering.git")
</pre>

Ensure you have all the required products ([listed below](#H_E850B4FF)) installed. If you need to include a product, add it using the Add-On Explorer. To install an add-on, go to the **Home** tab and select  <img src="Images/image_1.png" width="16" alt="image_1.png"> **Add-Ons** > **Get Add-Ons**. 

<a name="H_E850B4FF"></a>
## Products

MATLAB®, Simulink®, Stateflow™, Symbolic Math Toolbox™, MATLAB Support package for Arduino, Simulink Support package for Arduino.

<a name="H_E8C62B23"></a>
# Scripts

 *If you are viewing this in a version of MATLAB prior to R2023b, you can view the learning outcomes for each script* [*here.*](https://www.mathworks.com/matlabcentral/fileexchange/156477-introduction-to-engineering-with-arduino)

<a name="H_035F075E"></a>
## [**SupportArduino.mlx**](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=SupportArduino.mlx)
| | **In this script, students will...** |
| :-- | :-- |
| <img src="Images/image_2.png" width="171" alt="image_2.png"> |  <br>-  Check their Arduino board compatibility. <br>-  Install MATLAB and Simulink support packages for Arduino Hardware. <br>-  Setup ThingSpeak channel for IoT.  |


<a name="H_E8C62B23"></a>
## [BlinkToSOS.mlx](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=BlinkToSOS.mlx)
| | **In this script, students will...** |
| :-- | :-- |
| <img src="Images/image_3.png" width="171" alt="image_3.png"> |-  Learn the fundamental type of signals supported on and Arduino board. <br>-  Wire a simple LED to their Arduino board. <br>-  Control the LED from a simple blink to encoding Morse code.  |

<a name="H_23B77A06"></a>
## [**ReactionAnalyzer.mlx**](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=ReactionAnalyzer.mlx)
| | **In this script, students will...** |
| :-- | :-- |
| <img src="Images/image_4.png" width="171" alt="image_4.png"> | -  Learn how to control Arduino with a Stateflow diagram. <br>-  Learn data analysis techniques. <br>-  Write and export experiment report from MATLAB.  |

<a name="H_51CBB9CC"></a>
## [**GreenhouseControl.mlx**](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=GreenhouseControl.mlx)
| | **In this script, students will...** |
| :-- | :-- |
| <img src="Images/image_5.png" width="171" alt="image_5.png"> | -  Use a temperature sensor. <br>-  Develop a control algorithm. <br>-  Test their control algorithm.  |

<a name="H_51CBB9CC"></a>
## [**GreenhouseModel.mlx**](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=GreenhouseModel.mlx)
| | **In this script, students will...** |
| :-- | :-- |
| <img src="Images/image_6.png" width="171" alt="image_6.png"> |-  Use a Simscape thermal model. <br>-  Simulate the greenhouse over a full year of data. <br>-  Test multiple fans to validate the design.  |


<a name="H_51CBB9CC"></a>
## [**ConnectedGreenhouse.mlx**](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Intro-To-Engineering&project=intro-to-engineering.prj&file=ConnectedGreenhouse.mlx)
| | **In this script, students will...** |
| :-- | :-- |
| <img src="Images/image_7.png" width="171" alt="image_7.png"> | -  Learn how to read and write from a ThingSpeak channel. <br>-  Log the temperature in the greenhouse on their own channel. <br>-  Create an alert when the temperature exceeds the acceptable range.  |

# Related Courseware Modules
## [**Robotic Manipulators**](https://www.mathworks.com/matlabcentral/fileexchange/130124-robotic-manipulators) 
| | **Available on:** |
| :-- | :-- |
| <img src="Images/image_8.png" width="171" alt="image_8.png"> |[<img src="Images/image_9.png" width="129" alt="image_9.png">](https://www.mathworks.com/matlabcentral/fileexchange/130124-robotic-manipulators)<br> [<img src="Images/image_10.png" width="156" alt="image_10.png">](https://matlab.mathworks.com/open/github/v1?repo=MathWorks-Teaching-Resources/Robotic-Manipulators&project=Robotic-Manipulators.prj)<br>[GitHub](https://github.com/MathWorks-Teaching-Resources/Robotic-Manipulators)  |


Or feel free to explore our other [modular courseware content](https://www.mathworks.com/matlabcentral/fileexchange/?q=tag%3A%22courseware+module%22&sort=downloads_desc_30d).

# Educator Resources
-  [Educator Page](https://www.mathworks.com/academia/educators.html) 
<a name="H_0FA5DA18"></a>
# Contribute 

Looking for more? Find an issue? Have a suggestion? Please contact the [MathWorks teaching resources team](mailto:%20onlineteaching@mathworks.com). If you want to contribute directly to this project, you can find information about how to do so in the [CONTRIBUTING.md](https://github.com/MathWorks-Teaching-Resources/Intro-To-Engineering/blob/release/CONTRIBUTING.md) page on GitHub.


Copyright 2023 The MathWorks™, Inc



