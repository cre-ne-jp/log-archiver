/* eslint no-console:0 */

const flatpickrOf = (element) => element.parentElement._flatpickr;

const index = () => {
  console.log("welcome/index");

  const inputMessageSearchSince = document.getElementById("message_search_since");
  const inputMessageSearchUntil = document.getElementById("message_search_until");

  const flatpickrSince = flatpickrOf(inputMessageSearchSince);
  const flatpickrUntil = flatpickrOf(inputMessageSearchUntil);

  const dateFromArray = (dates) => (dates.length < 1) ? null : dates[0];

  flatpickrSince.set("onChange", (selectedDates, dateStr, instance) => {
    flatpickrUntil.set("minDate", dateFromArray(selectedDates));
  });

  flatpickrUntil.set("onChange", (selectedDates, dateStr, instance) => {
    flatpickrSince.set("maxDate", dateFromArray(selectedDates));
  });
};

export default {
  index,
};
