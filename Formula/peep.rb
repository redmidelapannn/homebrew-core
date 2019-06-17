class Peep < Formula
  desc "Unobtrusive CLI text viewer; shows files through a small pane"
  homepage "https://github.com/ryochack/peep"
  url "https://github.com/ryochack/peep/archive/v0.1.4.tar.gz"
  sha256 "f96aefc41d041402f185b4ab14c0f4a31db62a6ed49eae015427b4e2d50b4b6b"
  head "https://github.com/ryochack/peep.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix,
                               "--path", "."
  end

  test do
    system "#{bin}/peep", "--version", "peep 0.1.4"
  end
end
