class Imgcat < Formula
  desc "Displays one or more images inline at their full size."
  homepage "https://www.iterm2.com/documentation-images.html"
  url "https://raw.githubusercontent.com/gnachman/iTerm2/master/tests/imgcat"
  version "0.0.1"
  sha256 "5d471f24d512143796b81de873fb7b6660b0a57bc1c99bb26fd1c9ef8dff64de"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf2aaa69e4822f5a0d5e8a993e7569ee417bb3d01a8829699fbda3948a41926b" => :sierra
    sha256 "c763984fcb2bcfce40a5807fb277cf9bd0d8095e1f3e82c88bebf7ea07385eda" => :el_capitan
    sha256 "472dcacb60d9073120da7369882dbfa11bf9ea56945448a4d958e4425bd84234" => :yosemite
  end

  def install
    bin.install "imgcat"
  end

  test do
    test_fixtures("test.png")
    system "#{bin}/imgcat", "test.png"
  end
end
