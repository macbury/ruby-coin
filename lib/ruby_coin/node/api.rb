# frozen_string_literal: true

module RubyCoin
  module Node
    class Api < Rack::App
      headers 'Access-Control-Allow-Origin' => '*', 'Content-type' => 'application/json'
      serializer { |obj| JSON.dump(obj) }

      error Social::Errors::NotSupportedAction do |ex|
        response.status = 500
        { error: ex.message }
      end

      payload do
        parser do
          accept :json
          reject_unsupported_media_types
        end
      end

      get '/' do
        block = Application.current.chain.last
        {
          type: 'RubyCoin',
          time: Time.now,
          index: block&.index,
          hash: block&.hash,
          prev_hash: block&.prev_hash
        }
      end

      desc 'Fetch block with index or hash'
      validate_params { required 'index', class: String }
      get '/blocks/:index' do
        block = Application.current.chain[params['index']]

        if block
          block.to_h
        else
          response.status = 404
          nil
        end
      end

      post '/actions' do
        # validate action signature, and check if can perform operation
        # add to pending action
        action = Social::Action.build(payload || {})
        puts action.inspect
      end
    end
  end
end
