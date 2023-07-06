module HTMLizer
  class << self
    def options_viewer(where, safesearch)
      (Markaby::Builder.new {
        h1 "Your Options"
        p do
          text "Your language and location are currently set to #{langhash().invert[where]}"
          br
          text "#{if safesearch == "true" then "✅" else "❌" end} SafeSearch"
        end
        a href: "/options" do
          text "Edit"
        end
        2.times { br }
        a href: "/" do
          text "Back to Home"
        end
      }).to_s
    end
  end
end
