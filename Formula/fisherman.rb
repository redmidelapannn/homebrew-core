class Fisherman < Formula
  desc "fish plugin manager"
  homepage "https://github.com/fisherman/fisherman"

  url "https://raw.githubusercontent.com/fisherman/fisherman/2.12.0/fisher.fish"
  sha256 "3fa4c7c9a222dca46f7d279989ceb2fff1cc0f30e4f2815bbcd5afe7f8bc3d1e"

  head "https://github.com/fisherman/fisherman.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "128ab97f550b58d4cab8cf71ab452b2e2872c6d8dfae7593dcc5e64fabfe1bd9" => :sierra
    sha256 "1a0a54420714dace803cc673217693874b27f53ca7cd251b45bd07361e64ddf5" => :el_capitan
    sha256 "d3101f67656eda2d1f4c7abfadf96549287bae0229ac5f80f6ac6cb023fb06e8" => :yosemite
  end

  depends_on "fish"

  def install
    (share/"fish/vendor_functions.d/").install "fisher.fish"
    File.write("fisher-completion.fish", "fisher --complete")
    fish_completion.install "fisher-completion.fish" => "fisher.fish"
    ohai "You may need to restart any open terminal sessions for changes to take effect."
  end
end
