/* eslint no-console:0 */

import { flatpickrFor } from "../flatpickr_helper";

const onLoad = () => {
  console.log("welcome/index");

  const flatpickrPairs = [
    {
      since: flatpickrFor("message_search_since"),
      until: flatpickrFor("message_search_until")
    },
    {
      since: flatpickrFor("message_period_since"),
      until: flatpickrFor("message_period_until")
    },
  ];

  const dateFromArray = (dates) => (dates.length < 1) ? null : dates[0];

  flatpickrPairs.forEach(({ since, until }) => {
    if (since.selectedDates !== null) {
      until.set("minDate", dateFromArray(since.selectedDates));
    }

    if (until.selectedDates !== null) {
      since.set("maxDate", dateFromArray(until.selectedDates));
    }

    since.set("onChange", (selectedDates, dateStr, instance) => {
      until.set("minDate", dateFromArray(selectedDates));
    });

    until.set("onChange", (selectedDates, dateStr, instance) => {
      since.set("maxDate", dateFromArray(selectedDates));
    });
  });
};

export default onLoad;
