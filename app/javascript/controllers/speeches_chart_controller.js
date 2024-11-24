/* eslint no-console:0 */

import { Controller } from "stimulus";
import { Chart } from "chart.js/auto";
import MessageListStyle from "../message_list_style";

class SpeechesChartController extends Controller {
  static targets = [
    "dateListItem",
    "chart",
  ];

  static classes = [
    "link",
  ];

  connect() {
    if (this.dateListItemTargets.length <= 0) {
      // グラフが存在しなければ何もしない
      return;
    }

    this.dates = [];

    const labels = [];
    const values = [];
    const data = {
      labels,
      datasets: [{
        label: "発言数",
        data: values,
        backgroundColor: "#E64A19",
      }],
    };

    this.dateListItemTargets.forEach(item => {
      this.dates.push(item.dataset.date);
      labels.push(item.dataset.day);
      values.push(parseInt(item.dataset.numOfSpeeches, 10));
    });

    this.chart = new Chart(this.chartTarget, {
      type: "bar",
      data,
      options: {
        scales: {
          y: {
            beginAtZero: true
          }
        },

        plugins: {
          legend: { display: false },

          tooltip: {
            callbacks: {
              // SpeechesChartControllerのthisを使いたいため、アロー関数にする
              title: (tooltipItems, _data) => {
                const tooltipItem = tooltipItems[0];
                return this.dates[tooltipItem.dataIndex];
              },
            }
          },
        },

        // SpeechesChartControllerのthisを使いたいため、アロー関数にする
        onHover: (_e, elements, _c) => {
          const chartClassList = this.chartTarget.classList;

          if (elements[0] === undefined) {
            chartClassList.remove(this.linkClass);
          } else {
            chartClassList.add(this.linkClass);
          }
        },

        animation: { duration: 400 },
      },
    });

    this.chartTarget.classList.add("chartjs-render-monitor");
  }

  /**
   * クリックされた日付に対応するページに移動する。
   * @param {MouseEvent} e クリックに関するマウスイベント。
   */
  goToDayPage(e) {
    const activePoints = this.chart.getElementsAtEventForMode(
      e, 'index', { intersect: true }, false
    );
    const clicked = activePoints[0];
    if (clicked === undefined) {
      return;
    }

    // YYYY-mm-ddの9文字目から→dd
    const dd = this.dates[clicked.index].slice(8);
    const dayPath = `${document.location.pathname}/${dd}`;
    const href = MessageListStyle.get() === "raw" ?
      `${dayPath}?style=raw` : dayPath;

    document.location.href = href;
  }
}

export default SpeechesChartController;
