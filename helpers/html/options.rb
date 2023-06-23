module HTMLizer
  def self.options_viewer(where, safesearch)
    (Markaby::Builder.new do
      h1 "Your Options"
      p do
        text "Your language and location are currently set to #{langhash().invert[where]}"
        br
        text "Your SafeSearch is currently set to #{if safesearch == "true" then "strict" else "moderate" end}"
      end
      a href: "/options" do
        text "Edit"
      end
      br
      br
      a href: "/" do
        text "Back to Home"
      end
    end).to_s
  end
end
