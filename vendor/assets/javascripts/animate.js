/*
  svgAnimation.js v1.0.0
  Licensed under the MIT license.
  http://www.opensource.org/licenses/mit-license.php

  Copyright 2016
  http://www.hellomichael.com/
*/

; (function(window) {
  'use strict';

  var svgAnimation = function (options) {
    var self = this;
    self.options = extend({}, self.options);      
    extend(self.options, options);
    self.init();
  };

  svgAnimation.prototype = {
    constructor: svgAnimation,

    options: {
      data:                 null,
      canvas:               null,
      svg:                  null,
      id:                   null,    
      animations_array:     null,
      elements_dict:       {}, 
      play_interval: null,
      on_element: false
   },


    init: function() {
      var self = this;
      self.options.animations_array = [];
      self.loadJSON(self.options.data, function (data) {
        self.loadSVG(self.options.canvas, self.options.svg, data.animations);
      });
    },

    /*
      Loads the SVG into the DOM
      @param {Object}   canvas
      @param {String}   svg
      http://stackoverflow.com/questions/9723422/is-there-some-innerhtml-replacement-in-svg-xml
    */
    loadJSON: function(data, callback) {
      var self = this;
      // XML request
      var xobj = new XMLHttpRequest();
      xobj.open('GET', data, true);

      xobj.onreadystatechange = function() {
        // Success
        if (xobj.readyState === 4 && xobj.status === 200) {
          var json = JSON.parse(xobj.responseText);

          if (callback && typeof(callback) === "function") {
            callback(json);
          }
        }
      };

      xobj.send(null);
    },

    /*
      Loads the SVG into the DOM and creates tweens ready for playback

      @param {Object}   canvas
      @param {String}   svg
      @param {Array}    animations
      @param {Int}      duration 
      @param {Function} callback 
    */

    loadSVG: function(canvas, svg, animations) {
      var self = this;
      self.load = 1;
      Snap.load(svg, function(data) {
        // Place SVG nodes into DOM tree
        canvas.append(data);
        self.options.elements_dict = {};

        // Create tweens for each animation
        animations.forEach(function(animation) {
          var element = self.options.elements_dict[animation.id];
          if(element == null) {
            element = canvas.select(animation.id); 
            // Create scale, rotate, and transform groups around an SVG node
            self.createTransformGroup(element);
            self.options.elements_dict[animation.id] = element;
          }
          // Create tween based on keyframes
          if (animation.keyframes.translateKeyframes) {
            self.options.animations_array.push(new svgTween({
              owner: self.options,
              id: animation.id,
              animation_id: animation.animation_id,
              element: element.select('.translate'),
              keyframes: animation.keyframes.translateKeyframes,
              duration: animation.duration/animation.steps,
              steps: animation.steps,
              next_animation_id: animation.next_animation_id,
              next_animation_step: animation.next_animation_step,
              final_animation_id: animation.final_animation_id,
              queue_id: animation.queue_id ? animation.queue_id : 1
            }));
          }

          if (animation.keyframes.rotateKeyframes) {
           self.options.animations_array.push(new svgTween({
              owner: self.options,
              id: animation.id,
              animation_id: animation.animation_id,
              element: element.select('.rotate'),
              keyframes: animation.keyframes.rotateKeyframes,
              duration: animation.duration/animation.steps,
              steps: animation.steps,
              next_animation_id: animation.next_animation_id,
              next_animation_step: animation.next_animation_step,
              final_animation_id: animation.final_animation_id,
              queue_id: animation.queue_id ? animation.queue_id : 1
            }));

          }

          if (animation.keyframes.scaleKeyframes) {
             self.options.animations_array.push(new svgTween({
              owner: self.options,
              id: animation.id,
              animation_id: animation.animation_id,
              element: element.select('.scale'),
              keyframes: animation.keyframes.scaleKeyframes,
              duration: animation.duration/animation.steps,
              steps: animation.steps,
              next_animation_id: animation.next_animation_id,
              next_animation_step: animation.next_animation_step,
              final_animation_id: animation.final_animation_id,
              queue_id: animation.queue_id ? animation.queue_id : 1
            }));
          }

          if (animation.keyframes.opacityKeyframes) {
            self.options.animations_array.push( new svgTween({
              owner: self.options,
              id: animation.id,
              animation_id: animation.animation_id,
              element: element.select('.opacity'),
              keyframes: animation.keyframes.opacityKeyframes,
              duration: animation.duration/animation.steps,
              steps: animation.steps,
              next_animation_id: animation.next_animation_id,
              next_animation_step: animation.next_animation_step,
              final_animation_id: animation.final_animation_id,
              queue_id: animation.queue_id ? animation.queue_id : 1
            }));
          }

        });

        set_next_animations(self);

        $(self.options.id).hover(
          function(){
              self.options.on_element = true;
              self.play_animations();
          }, 
          function(){
              self.options.on_element = false;
          } 
        );

        $(self.options.id).click(
          function(){
              self.options.on_element = false;
          } 
        );

      });

    },

    play_animations: function() {
        var self = this;
        self.options.animations_array.forEach(function(anim){
           if(anim.options.queue_id == 1){
              anim.play();
           }
        });
    },



    /*
      Create scale, rotate, and transform groups around an SVG DOM node
      @param {object} Snap element
    */
    createTransformGroup: function(element) {
      if (element.node) {
        if (element.node) {
          var childNodes = element.selectAll('*');
          element.g().attr('class', 'translate')
            .g().attr('class', 'rotate')
            .g().attr('class', 'scale')
            .g().attr('class', 'opacity')
            .append(childNodes);
        }
      }
    }
  };

  function set_next_animations(self) {
    self.options.animations_array.forEach(function(anim){
      anim.options.next_animation_tween = get_svgTween_by_anim_id(self, anim.options.next_animation_id);
      anim.options.final_animation_tween = get_svgTween_by_anim_id(self, anim.options.final_animation_id);
      if(anim.options.final_animation_tween == null) {
        anim.options.final_animation_tween = anim.options.next_animation_tween;
      }
    });
  }

  function get_svgTween_by_anim_id(self, id) {
    var result = null;
    self.options.animations_array.forEach(function(anim){
      if(anim.options.animation_id == id) {
        result = anim;
      }
    });
    return result;
  }

  var svgTween = function (options) {
    var self = this;
    self.options = extend({}, self.options);      
    extend(self.options, options);
    self.init();
  };

  svgTween.prototype = {
    constructor: svgTween,

    options: {
      owner:      null, 
      id:         null,
      element:    null,
      type:       null,
      keyframes:  null,
      duration:   null,
      originX:    null,
      originY:    null,
      steps:      null,
      interval:   null,
      next_animation_id: null,
      next_animation_tween: null,
      next_animation_step: null,
      final_animation_id: null,
      final_animation_tween: null,
      queue_id:   null,
      is_playing: false,
      time: 0
    },



    init: function () {
      var self = this;
      // Set type
      self.options.type = self.options.element.node.getAttributeNode('class').value;
    },

    play: function(){
      var self = this;
      if (self.options.is_playing && self.options.queue_id != -1) {
        return;
      }
      else if(self.options.next_animation_id != null && self.options.queue_id == 1 && self.options.final_animation_tween.options.is_playing ) {
        return;
      }
      if(self.options.queue_id == 1 && self.options.final_animation_id != null) {
        self.options.final_animation_tween.options.is_playing = true;
      }
      // Set bbox to specific transform element (.translate, .scale, .rotate)
      var bBox = self.options.element.getBBox();
      var total_dur = self.options.steps * self.options.duration;
      self.play_animation(self, bBox);
    },



    play_animation: function(self, bBox) {
      self.options.is_playing = true;
      self.options.originX = self.options.keyframes[0].cx ? self.getOriginX(bBox, self.options.keyframes[0].cx) : self.getOriginX(bBox, 'center');
      self.options.originY = self.options.keyframes[0].cy ? self.getOriginY(bBox, self.options.keyframes[0].cy) : self.getOriginY(bBox, 'center');
    // Reset and play tween
      self.resetTween(self.options.element, self.options.type, self.options.keyframes, self.options.originX, self.options.originY);
      self.options.time = new Date().getTime();
      self.playTween(self.options.element, self.options.type, self.options.keyframes, self.options.originX, self.options.originY, self.options.duration, 0);
    },

      /*
      Recursively loop through keyframes to create pauses or tweens

      @param {Object} element
      @param {String} type - "scale", "rotate", "translate", "opacity"
      @param {Array}  keyframes
      @param {String} originX - "left", "right", "center"
      @param {String} originY - "top", "bottom", "center"
      @param {Int}    duration 
      @param {Int}    index
    */
    playTween: function(element, type, keyframes, originX, originY, duration, index) {
      var self = this, transform, translateX, translateY, rotationAngle, scaleX, scaleY, newDuration, easing;
      var newOriginX = keyframes[index].offsetX ? originX + keyframes[index].offsetX : originX;
      var newOriginY = keyframes[index].offsetY ? originY + keyframes[index].offsetY : originY;
      // Set keyframes we're transitioning to
      if (type === 'translate') {
        translateX = keyframes[index].x;
        translateY = keyframes[index].y;
        transform = 'T ' + translateX + ' ' + translateY;
      }

      else if (type === 'rotate') {
        rotationAngle = keyframes[index].angle;
        transform = 'R ' + rotationAngle + ' ' + newOriginX + ' ' + newOriginY;
      }

      else if (type === 'scale') {
        scaleX = keyframes[index].x;
        scaleY = keyframes[index].y;
        transform = 'S ' + scaleX + ' ' + scaleY + ' ' + originX + ' ' + originY;
      }

      else if (type === 'opacity') {
        transform = keyframes[index].opacity;
      }

      // Set duration as an initial pause or the difference of steps in between keyframes
      newDuration = index ? ((keyframes[index].step - keyframes[(index-1)].step) * duration) : (keyframes[index].step * duration);
      // Set easing parameter
      easing = mina[keyframes[index].easing];
      // Skip first tween if animation immediately starts on step 0
      if (index === 0 && keyframes[index].step === 0) {
        self.playTween(element, type, keyframes, originX, originY, duration, (index + 1));
      }


      // Or pause tween if initial keyframe
      else if (index === 0 && keyframes[index].step !== 0) {
        setTimeout(function() {
          if (index !== (keyframes.length - 1)) {
            self.playTween(element, type, keyframes, originX, originY, duration, (index + 1));
          }
       }, newDuration);
      }
      

      // Or animate tweens if keyframes exist
      else {
        if(type === 'opacity') {
          element.animate({
            opacity: transform
          }, newDuration, easing, function() {     
            if (index !== (keyframes.length - 1)) {
              self.playTween(element, type, keyframes, originX, originY, duration, (index + 1));
            }else {
              self.options.is_playing = false;  
              check_if_continue(self);            
            }

          });
        }
        else {
          element.animate({
            transform: transform
          }, newDuration, easing, function() {       
            if (index != (keyframes.length - 1)) {
              self.playTween(element, type, keyframes, originX, originY, duration, (index + 1));
            } else {
              self.options.is_playing = false;  
              check_if_continue(self);
            }
          });
      }

      }
    },

    /*
      Resets the illustration to the first keyframe

      @param {Object} element
      @param {String} type - "scale", "rotate", "translate"
      @param {Array}  keyframes
      @param {String} originX - "left", "right", "center"
      @param {String} originY - "top", "bottom", "center"
    */
    resetTween: function (element, type, keyframes, originX, originY) {
      var transform, translateX, translateY, rotationAngle, scaleX, scaleY;
      var newOriginX = keyframes[0].offsetX ? originX + keyframes[0].offsetX : originX;
      var newOriginY = keyframes[0].offsetY ? originY + keyframes[0].offsetY : originY;
      if (type === 'translate') {
        translateX = keyframes[0].x;
        translateY = keyframes[0].y;
        transform = 'T ' + translateX + ' ' + translateY;
      }
      else if (type === 'rotate') {
        rotationAngle = keyframes[0].angle;
        transform = 'R ' + rotationAngle + ' ' + newOriginX + ' ' + newOriginY;
      }

      else if (type === 'scale') {
        scaleX = keyframes[0].x;
        scaleY = keyframes[0].y;
        transform = 'S ' + scaleX + ' ' + scaleY + ' ' + originX + ' ' + originY;
      }

      else if (type === "opacity"){
        element.attr("opacity", keyframes[0].opacity);
        return;
      }

      else if (type === "alongpath"){
        return;
      }
      element.transform(transform);
      
    },

    /*
      Translates the horizontal origin from a string to pixel value

      @param {Object}     Snap bBox
      @param {String}     "left", "right", "center"
      @return {Object}    pixel value
    */
    getOriginX: function (bBox, direction) {
      if (direction === 'left') {
        return bBox.x;
      }

      else if (direction === 'center') {
        return bBox.cx;
      }

      else if (direction === 'right') {
        return bBox.x2;
      }
    },

    /*
      Translates the vertical origin from a string to pixel value

      @param {Object}     Snap bBox
      @param {String}     "top", "bottom", "center"
      @return {Object}    pixel value
    */
    getOriginY: function (bBox, direction) {
      if (direction === 'top') {
        return bBox.y;
      }

      else if (direction === 'center') {
        return bBox.cy;
      }

      else if (direction === 'bottom') {
        return bBox.y2;
      }
    }
  };


  function check_if_continue(self) {
    if( (self.options.queue_id != -1 || self.options.owner.on_element) && self.options.next_animation_id != null) {
      self.options.next_animation_tween.play();
    }         
    else if(self.options.owner.on_element && self.options.next_animation_id == null){
      self.play();
    }
  }

  /*
    Merges two objects together
    @param  {Object}  a 
    @param  {Object}  b
    @return {Object}  sum
    http://stackoverflow.com/questions/11197247/javascript-equivalent-of-jquerys-extend-method
  */
  function extend(a, b) {
    for (var key in b) { 
      if (b.hasOwnProperty(key)) {
        a[key] = b[key];
      }
    }

    return a;
  }



function debounce(func, wait, immediate) {

    var timeout;           

    // Calling debounce returns a new anonymous function
    return function() {
        var context = this, 
            args = arguments;

        var callNow = immediate && !timeout;
        clearTimeout(timeout);   
        timeout = setTimeout(function() {
             timeout = null;
             if (!immediate) {
               func.apply(context, args);
             }
        }, wait);
        if (callNow) func.apply(context, args);  
     }; 
};

  function animateAlongPath(path, element, start, dur, callback) {
    // Get the path length, so we know how many frames we will animate over
    var len = Snap.path.getTotalLength(path);
    Snap.animate(start, len, function (value) {
      // movePoint gets the path attributes at a certain frame
      var movePoint = Snap.path.getPointAtLength(path, value);
      console.log(movePoint);
      // applies the attributes to our element
      element.attr({ cx: movePoint.x, cy: movePoint.y });
    }, 100, mina.easeinout, function () {
      callback(path);
    });
  };


  // Add to global namespace
  window.svgAnimation = svgAnimation;
  window.svgTween = svgTween;
})(window);

