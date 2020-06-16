var getDomNodesToProcess = function(className) {
  return [].slice.call(document.querySelectorAll(className))
}

var showMore = function(domNode) {
  domNode.querySelector('.js-readMore-showMore').classList.add('d-none')
  domNode.querySelector('.js-readMore-short').classList.add('d-none')
  domNode.querySelector('.js-readMore-full').classList.remove('d-none')
  domNode.querySelector('.js-readMore-showLess').classList.remove('d-none')
}

var showLess = function(domNode) {
  domNode.querySelector('.js-readMore-showMore').classList.remove('d-none')
  domNode.querySelector('.js-readMore-short').classList.remove('d-none')
  domNode.querySelector('.js-readMore-full').classList.add('d-none')
  domNode.querySelector('.js-readMore-showLess').classList.add('d-none')
}

var initReadMore = function(className) {
  getDomNodesToProcess(className).forEach(function(domNode) {
    domNode
      .querySelector('.js-readMore-showMore')
      .addEventListener('click', function() {
        showMore(domNode)
      })

    domNode
      .querySelector('.js-readMore-showLess')
      .addEventListener('click', function() {
        showLess(domNode)
      })
  })
}

Spree.ready(function($) {
  initReadMore('.js-readMore')
}) 
