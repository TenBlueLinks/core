module HTMLizer
  class << self
    def options_viewer(where, safesearch)
      mab {
        h1 "Your Options"
        p do
          text "Your language and location are currently set to #{Engines.Languages.invert[where]}"
          br
          text "#{if safesearch == "true" then "✅" else "❌" end} SafeSearch" # unicode emojis breaking old browsers
        end
        a href: "/options" do
          text "Edit"
        end
        2.times { br }
        a href: "/" do
          text "Back to Home"
        end
      }
    end
  end
end
