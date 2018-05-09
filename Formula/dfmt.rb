class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.7.0",
      :revision => "4168c232ab9b3698afc891a72767fc97c83345df"

  head "https://github.com/dlang-community/dfmt.git", :branch => "v0.x.x", :shallow => false

  bottle do
    rebuild 1
    sha256 "08f70bb6168c4f0001ae8df93d162f50aa69acdc3c924c5ba363c53ab396a016" => :high_sierra
    sha256 "d82f819a58ca5ff82c354a7b5d6bd704652448166db99eb01255791db58cac73" => :sierra
    sha256 "915656b60572344486bcc0fa1855f3fa61cc042ddb7d1c2997220b5563129e5d" => :el_capitan
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dfmt"
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio; void main() { writeln("Hello, world without explicit compilations!"); }
    EOS

    expected = <<~EOS
      import std.stdio;

      void main()
      {
          writeln("Hello, world without explicit compilations!");
      }
    EOS

    system "#{bin}/dfmt", "-i", "test.d"

    assert_equal expected, (testpath/"test.d").read
  end
end
