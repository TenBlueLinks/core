module HTMLizer
  def self.about()
    mab do
      div align: "center" do
        p do
          text "01110100 01100101 01101110 01000010"
          br
          text "01101100 01110101 01100101 01001100"
          br
          text "01101001 01101110 01101011 01110011"
        end
        2.times { br }
        p "tenBlueLinks is a simple search engine designed for old browsers and slow internet connections."
        a "Back to Home", href: "/"
      end
    end
  end
end

class TenBlueLinks
  get "/about" do
    @title = "About"
    erb :about
  end
end
