#
# Wire
# Copyright (C) 2016 Wire Swiss GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#

window.z ?= {}
z.ViewModel ?= {}


class z.ViewModel.SettingsListViewModel
  constructor: (element_id) ->
    @logger = new z.util.Logger 'z.ViewModel.ArchiveViewModel', z.config.LOGGER.OPTIONS

    @is_settings_visible = ko.observable()

    @should_update_scrollbar = (ko.computed =>
      return @is_settings_visible()
    ).extend notify: 'always', rateLimit: 500

    @_init_subscriptions()

    ko.applyBindings @, document.getElementById element_id

  _init_subscriptions: =>
    amplify.subscribe z.event.WebApp.SETTINGS.SHOW, @open
    amplify.subscribe z.event.WebApp.SEARCH.SHOW, @close
    amplify.subscribe z.event.WebApp.SETTINGS.CLOSE, @close

  open: =>
    $(document).on 'keydown.show_settings', (event) ->
      amplify.publish z.event.WebApp.SETTINGS.CLOSE if event.keyCode is z.util.KEYCODE.ESC
    @is_settings_visible Date.now()
    @_show()

  close: =>
    $(document).off 'keydown.show_settings'
    @_hide()

  ###############################################################################
  # Archive animations
  ###############################################################################
  _show: ->
    $('#settings').addClass 'settings-is-visible'

  _hide: ->
    $('#settings').removeClass 'settings-is-visible'
