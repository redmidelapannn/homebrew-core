class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.31.0/fonttools-3.31.0.zip"
  sha256 "c9a726a29fb4e573ee18b296e0a193ca18bc3d3ecf1c78bd4d92c77aa7a92752"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "685b7390ca68852875ff92082eeb17f44d86bf4630bac1b3aaef17b0ca7c5b3e" => :mojave
    sha256 "1abc47b913c59c0812f84629a3fc0abfd998c26336df32dd8b9feb9b6dced86e" => :high_sierra
    sha256 "36cb7c155c4f18e963647a41024fcf0bff82293281b94ebd4acb35f8c4235ab0" => :sierra
    sha256 "b44296025ff97aa5ae3852bd70be5e682c1e767d55fa5a8d5654f29b81eb2499" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
