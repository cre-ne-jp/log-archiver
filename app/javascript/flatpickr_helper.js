const flatpickrFor = (prefix) =>
  document.getElementById(`${prefix}-flatpickr`)._flatpickr;

const dateFromArray = (dates) => (dates.length < 1) ? null : dates[0];

const setMinMaxOnDateSelection = (since, until) => {
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
};

export {
  flatpickrFor,
  setMinMaxOnDateSelection,
};
