/* eslint no-console:0 */

import {
  flatpickrFor,
  setMinMaxOnDateSelection,
} from "../../flatpickr_helper";

const onLoad = () => {
  console.log("messages/periods/show");

  setMinMaxOnDateSelection(
    flatpickrFor("message_period_since"),
    flatpickrFor("message_period_until")
  );
};

export default onLoad;
