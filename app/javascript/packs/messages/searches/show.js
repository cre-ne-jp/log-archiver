/* eslint no-console:0 */

import {
  flatpickrFor,
  setMinMaxOnDateSelection,
} from "../../flatpickr_helper";

const onLoad = () => {
  console.log("messages/searches/show");

  setMinMaxOnDateSelection(
    flatpickrFor("message_search_since"),
    flatpickrFor("message_search_until")
  );
};

export default onLoad;
