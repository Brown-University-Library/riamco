# Extracts text from files via a Tika Server
# See https://cwiki.apache.org/confluence/display/tika/TikaJAXRS#TikaJAXRS-GettheTextofaDocument
#
# java -jar tika-server-1.22.jar
# curl -X PUT --data-binary @sample.pdf localhost:9998/detect/stream
# curl -X PUT --data-binary @sample.pdf http://localhost:9998/tika --header "Content-type: application/pdf"
#
class TextExtractor
    def initialize(tika_url)
        if tika_url == nil
            raise "Must specify URL to Tika Server"
        end
        @tika_url = tika_url
    end

    def server_running?()
        uri = URI("#{@tika_url}/tika")
        response = Net::HTTP.get(uri) || ""
        response.include?("Tika Server")
    rescue => ex
        Rails.logger.error("Cannot connect to Tika Server: #{ex}")
        false
    end

    def get_type(content)
        uri = URI("#{@tika_url}/detect/stream")
        req = Net::HTTP::Put.new(uri)
        req.body = content
        response = Net::HTTP.new(uri.hostname, uri.port).start {|http| http.request(req) }
        response.body
    end

    def process_file(filename, type = nil)
        if !server_running?()
            return false, "Tika server is not running at the indicated URL"
        end

        content = File.read(filename)
        uri = URI("#{@tika_url}/tika")
        req = Net::HTTP::Put.new(uri)
        req["Content-type"] = type || get_type(content)
        req.body = content
        response = Net::HTTP.new(uri.hostname, uri.port).start {|http| http.request(req) }
        if response.code != "200"
            return false, "HTTP status #{response.code}"
        end
        return true, response.body
    end
end