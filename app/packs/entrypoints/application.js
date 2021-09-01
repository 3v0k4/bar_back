/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/packs and only use these pack files to reference
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

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import ClipboardJS from 'clipboard'

Rails.start()
Turbolinks.start()
ActiveStorage.start()
new ClipboardJS('.yyyy')

document.addEventListener("turbolinks:load", () => {
  addFontClass()
})

const addFontClass = () => {
  if (sessionStorage.fontsLoaded === "true") {
    document.documentElement.classList.add("fonts-loaded")
    return
  }

  if ("fonts" in document) {
    Promise.all([
      document.fonts.load('123px "JetBrains Mono"'),
      document.fonts.load('123px "Raleway"'),
    ]).then(() => {
      document.documentElement.classList.add("fonts-loaded")
      sessionStorage.fontsLoaded = "true"
    })
  }
}

