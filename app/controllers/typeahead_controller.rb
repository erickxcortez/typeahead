require 'json'

class TypeaheadController < ApplicationController

    def initialize
        self.load_data if !$trie
    end

    def load_data
        $limit_results = ENV['SUGGESTION_NUMBER'] ? ENV['SUGGESTION_NUMBER'].to_i : 10
        acesses_hash = Rails.cache.fetch('names_json') do
            file = File.read('names.json')
            JSON.parse(file)
        end
        $trie = Trie.new
        acesses_hash.map {|key, value| $trie.add_word(key, value) }
    end

    def get_data
        begin
            text = params[:text] ? $trie.clean_word(params[:text])  : ''
            result = $trie.find_words_starting_with(text,  $limit_results )
            render json: result, status: :ok

        rescue
            render status: 400, json: { msg: "Unexpected behavior"}
        end
    end

    def update_data
        begin
            if params[:name] == nil || params[:name] == ''
                render status: 400, json: { message: "Unexpected behavior" }
            else    
                text = params[:name]
                update_weight = true
                result = $trie.find_words_starting_with(text,  $limit_results, update_weight )
                if result.length > 0
                    render json: result[0], status: :ok
                else
                    render status: 400, json: { msg: "Unexpected behavior"}
                end
            end
        rescue
                render status: 400, json: { msg: "Unexpected behavior"}
        end
    end

end
