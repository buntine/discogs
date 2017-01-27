if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start 
end
require 'rubygems'
require 'rspec'
require File.dirname(__FILE__) + '/../lib/discogs'

# TODO: Remove after searhc is re-implemented.
def valid_search_xml(page=1)
  data = File.read(File.join(File.dirname(__FILE__), "samples", "valid_search_results_#{page}.xml"))
  data.gsub /\n/, ''
end

def read_sample(filename)
  data = File.read(File.join(File.dirname(__FILE__), "samples", "valid_#{filename}.json"))
  data.gsub /\n/, ''
end

def sample_valid_binary
  "\037\213\b\000\325\3054J\002\377\265T\337O\3330\020\376W,?L\233D\353\004(\203\315\215D\3304\020T\233V\006\017\323\036\214}4\036\211\035l\207\222\377~\227_U\v\025C\232\366\344\273\363\335\227/\337\335\231;\360%\361A\204)\265w\224<\200\363\332\232)\215\307\021%\016\356+\360\301\243K\023\356 \a\341\201h\205\376\036m\253*\274;\226\022\312\000\nSt!\026\340\373\223d\240\027\031\002\037D\210\025\352\022\246\324\203\264F\tWSR9=\245Y\b\345\a\306\226\313\345Xi/\355\302\217\245-X\213\303\276\217\342\275Q\034\037\306\373\321\321\321d2\376]\302\242\255\213'\321\337K'\321\326\362\245V!\3539\261\377\302\3640\376'\246\253\362'L;QP\\\341\202\306\246\fF\302\215( \231Ykd\246s\345\300p\326\2068\353R\223\301\300\232\240C\016I\n5\266\201\\\330\a\340\254\v\361\\\334@\216\031\355I\244\b\306N\351\247\375\213x7\212\336S\322 \242\017P\356_\350[\240\004\305cC\r<\006'\266\363:\267\372F\aK\336\210\242\374HR{W\r\354\234E&_C\006\216\374\234\227\332\351P\211\\\207\372\027g\355\325\300\372\311\217\236[Wo@\\Y)r\377r\321I\346\264'_\234\330,\275\306\217\0060\243\264\336!\337\234U\225\004\267Cf\372\021\024I1\365\t\017\266\371\237\267\326\025\242iDg\364\022]iS\347\224\334\207\272[\e\005^:]\006\\+L]\363\222x\227r\266\036\330\3600\231u\300+\003C\v0\270\262\375\231|\316A\006g\215\226\234\2657\230:d\370P\347Mf{&\227 3c9\353\274>\330t\223\234\332\312\343\024\364\027\335\211e\322V&\270:\3711\347l\260\207'@%8\023\321(:\034E\021\212\324\275\v\n\a\321\006\374b/\352\016);E\025\0218kE+*\376\020\312\213\356Lx\217o\005\231U^K\3626\235\235\275\ecW[\000\216\303$\357r\034r\234\327\306Lxi\275n\024L\216c\316V\316\v\323\254*'\232\202vL{\220gX\273\317\261\25630\344\004[%5\352BR|\257\n\360\030)\220zX-\313k\340\323-TOA<4\373\331\357\334\253`\266\260<3\270Q\227\031\220y\300\031|\021\216\255\2119\264\n\247\244y\367\223?4\242\342\264\376\005\000\000"
end

def sample_invalid_data
  <<-EOF
    <resp requests="2" stat="fail">
      <error>Missing or invalid User agent</error>
    </resp> 
  EOF
end

def mock_httparty(sample)
  @http_response = double(HTTParty::Response)
  @http_request = class_double(HTTParty).as_stubbed_const

  allow(@http_response).to receive_messages(:code => "200", :body => read_sample(sample))

  @http_request.should_receive(:get).and_return(@http_response)
end
