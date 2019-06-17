class Peep < Formula
  desc "Unobtrusive CLI text viewer; shows files through a small pane"
  homepage "https://github.com/ryochack/peep"
  url "https://github.com/ryochack/peep/archive/v0.1.4.tar.gz"
  sha256 "f96aefc41d041402f185b4ab14c0f4a31db62a6ed49eae015427b4e2d50b4b6b"
  head "https://github.com/ryochack/peep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcc8f26f09c981b38a000af4c4ed0797076e0b05d95ad017da02df3e27411e47" => :mojave
    sha256 "df5b6ac13093d14e43b2e4e533e95b063d90544744d4087011978a21fae1818b" => :high_sierra
    sha256 "07c7837a2473f88bfe02769ef2b9f6faa32cc8cfa86b4836d488890df159e979" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix,
                               "--path", "."
  end

  test do
    system "#{bin}/peep", "--version", "peep 0.1.4"
  end
end
