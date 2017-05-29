A library that generates an interactive radar that is tailored to satisfy the need of keeping the radar data private, inspired by [thoughtworks.com/radar](http://thoughtworks.com/radar).

This implementation is specifically designed to allow near-push-button readiness of displaying the application, as well as keeping data totally private for organizations that do not want their radar data in a published, totally open Google Sheet or similar spreadsheet file. All data is kept local to the docker image build artifact and the image is designed to be the final product, ready to pull and run anywhere for discussion or display/interaction.

## Basic Usage

* Clone the repo
* Save your radar data in the specified format (below)
* Build the image
* Supply a name as a build-arg if desired
* Run the image to view, interact, discuss, and print if desired

## Detailed Usage

### Setting up your data in spreadsheet

Create a spreadsheet. Give it at least the below column headers, and put in the content that you want:

| name          | ring   | quadrant               | isNew | description                                             |
|---------------|--------|------------------------|-------|---------------------------------------------------------|
| Composer      | adopt  | tools                  | TRUE  | Although the idea of dependency management ...          |
| Canary builds | trial  | techniques             | FALSE | Many projects have external code dependencies ...       |
| Apache Kylin  | assess | platforms              | TRUE  | Apache Kylin is an open source analytics solution ...   |
| JSF           | hold   | languages & frameworks | FALSE | We continue to see teams run into trouble using JSF ... |

### Prepare the sheet

* Name the sheet radar_data
* Save the sheet as a CSV file
* Transfer the sheet to the root of the Docker build context for this project

### Building the radar

* `docker build -t techradar-some-date-or-tag --build-arg doc_title=some-meaningful-name .`

That's it!

Note: the quadrants of the radar, and the order of the rings inside the radar will be drawn in the order they appear in your spreadsheet.

### Implementation details

The application uses [webpack](https://webpack.github.io/) to package dependencies and minify all .js and .scss files.

All tasks are defined in `package.json`.

After building it will start on localhost:80
