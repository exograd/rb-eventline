# Copyright (c) 2021-2022 Exograd SAS.
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

require("eventline/client")

module Eventline
  class Event
    attr_accessor(:id, :org_id, :trigger_id, :command_id, :creation_time, :event, :name,
      :data, :original_event_id)

    # Fetch a list of events.
    #
    # @param [Eventline::Client] client
    # @param [Hash] data
    #
    # @raise [Eventline::Client::RequestError]
    #
    # @return Eventline::Client::ListResponse
    def self.list(client, data = nil)
      request = Net::HTTP::Get.new("/v0/events")
      response = client.call(request)

      elements = response.fetch("elements", []).map do |element|
        event = new
        event.from_h(element)
        event
      end

      Client::ListResponse.new(elements, response["next"], response["previous"])
    end

    # Fetch an event by identifier.
    #
    # @param [Eventline::Client] client
    # @param [String] id
    #
    # @raise [Eventline::Client::RequestError]
    #
    # @return Eventline::Event
    def self.retrive(client, id)
      request = Net::HTTP::Get.new(File.join("/v0/events/id", id))
      response = client.call(request)
      event = new
      event.from_h(response)
      event
    end

    # Create a new custom event.
    #
    #
    # @param [Eventline::Client] client
    # @param [Hash] data
    #
    # @raise [Eventline::Client::RequestError]
    #
    # @return [Eventline::Event]
    def self.create(client, data)
      request = Net::HTTP::Post.new("/v0/events")
      request.body = JSON.dump(data)
      response = client.call(request)

      response.map do |element|
        event = new
        event.from_h(element)
        event
      end
    end

    # Replay an existing event.
    #
    # @param [Eventline::Client] client
    # @param [String] id
    #
    # @raise [Eventline::Client::RequestError]
    #
    # @return Eventline::Event
    def self.replay(client, id)
      request = Net::HTTP::Post.new(File.join("/v0/events", id, "replay"))
      response = client.call(request)
      event = new
      event.from_h(response)
      event
    end

    def initialize
    end

    # Load event from a hash object.
    #
    # @raise [KeyError]
    #
    # @return Eventline::Event
    def from_h(data)
      @id = data.fetch("id")
      @org_id = data.fetch("org_id")
      @trigger_id = data.fetch("trigger_id", nil)
      @command_id = data.fetch("command_id", nil)
      @creation_time = data.fetch("creation_time")
      @event_time = data.fetch("event_time")
      @name = data.fetch("name")
      @data = data.fetch("data")
      @original_event_id = data.fetch("original_event_id", nil)
      self
    end
  end
end
