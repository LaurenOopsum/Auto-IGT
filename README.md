## Instructions

The program works, but hasn't been exported yet. It must be run through the Godot engine, which was used to build it. To do so, follow these steps:

### The first time

To install the engine and import the program for the first time, follow these steps.

1. Download the GitHub repository and save it to a folder of your choosing.
2. Go to https://godotengine.org/ and click the button that says "Download LTS 3.5.3". (Note: NOT the latest version 4.whatever.)
3. Download the basic engine, extract the zip, and run. There is no installation step.
5. Click the button on the right that says "Import".
6. Click "Browse" and navigate to the folder where you saved the GitHub files.
7. Select the "project.godot" file and click "Import & Edit". This will automatically open the project in the editor. You don't want to be here.
8. In the top menu, click Project > Quit to Project List and click "Yes" when prompted to exit the editor.

### Running the program

Running the program from the engine is simple, once installed.

1. Open Godot. It will automatically open to the Project List. (If following the instructions above, this step is unnecessary.)
2. Select Auto IGT and click the "Run" button on the right.

## Limitations

Right now AIGT only handles .flextext files exported from FLEx. It also only copies LaTeX tables right now.

The file navigation system in the program isn't the best, so I recommend copying the path to your .flextext file from a system window and pasting it directly into the file selection dialog box in AIGT.

## Translations

AIGT has English and Spanish right now. More translations can be added/suggested here: https://docs.google.com/spreadsheets/d/1w3n8Ff-DTi8GeUK0UTBKm4_EODrW-OpYg7pKl0o-wV4/edit?usp=sharing

To add another language, include the langauge code at the top of the column (found here: https://docs.godotengine.org/en/3.5/tutorials/i18n/locales.html#doc-locales) and the translation of each row in the cell below.
