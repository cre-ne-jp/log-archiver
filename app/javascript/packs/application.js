/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

//import Rails from "@rails/ujs"
//import Turbolinks from "turbolinks"
//import * as ActiveStorage from "@rails/activestorage"
//import "channels"

require("bootstrap");
require("@fortawesome/fontawesome-free");

import "./use_flatpickr";

const moduleFileMap = {
  "messages/searches/show": "messages/searches/show",
  "messages/periods/show": "messages/periods/show",
  "welcome/index": "welcome/index",
};

document.addEventListener("DOMContentLoaded", async () => {
  const view = document.body.dataset.view;

  const moduleFile = moduleFileMap[view];
  if (moduleFile === undefined) {
    return;
  }

  let onLoad;
  try {
    const module = await import(`./${moduleFile}.js`);
    onLoad = module.default;
  } catch (e) {
    console.log(`${view}: ${e}`);
    return;
  }

  if (typeof onLoad === 'function') {
    onLoad();
  } else {
    console.log(`${view}: onLoad is not a function`);
  }
});

//Rails.start()
//Turbolinks.start()
//ActiveStorage.start()