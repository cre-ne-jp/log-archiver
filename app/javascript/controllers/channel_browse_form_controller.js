/* eslint no-console:0 */

import { Controller } from "@hotwired/stimulus";

class ChannelBrowseFormController extends Controller {
  static values = {
    dateType: String,
  };

  static targets = [
    "datePicker",
  ];

  connect() {
    this.updateDateType();
  }

  dateTypeValueChanged() {
    const dateTypeIsSpecify = (this.dateTypeValue === "specify");

    this.datePickerTarget.hidden = !dateTypeIsSpecify;
    this.formElement("date").required = dateTypeIsSpecify;
  }

  updateDateType() {
    this.dateTypeValue = this.formElement("date_type").value;
  }

  formElement(name) {
    return this.element.elements[`channel_browse[${name}]`];
  }
}

export default ChannelBrowseFormController;
