import { LightningElement } from 'lwc';
import chartJS from '@salesforce/resourceUrl/chartJS';
import { loadScript } from 'lightning/platformResourceLoader';

export default class ConsoleCaseCharts extends LightningElement {

    loadChartScript(value) {
        // load the script only once
        // Once its loaded, then directly call the methods to draw chart
        if (this.scriptLoaded) {
          this.callDrawPieChart(value);
        } else {
          this.scriptLoaded = true;
          loadScript(this, chartJS + "/Chart.min.js")
            .then(() => {
              this.callDrawPieChart(value);
            })
            .catch((error) => {
              console.log("Error:", error);
            });
        }
      }

      callDrawPieChart(value) {
        this.drawPieChart(
          value,
          {
            label1: "Total Cases",
            label2: "Total Deaths",
            label3: "TotalRecovered",
            chartLabel: "COVID-19 Data"
          },
          "div.chart1"
        );
      }

}