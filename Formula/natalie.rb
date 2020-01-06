class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.7.0.tar.gz"
  sha256 "f7959915595495ce922b2b6987368118fa28ba7d13ac3961fd513ec8dfdb21c8"
  head "https://github.com/krzyzanowskim/Natalie.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0cbd76e3886ba14b4f3ba33e5922650a267154a0af825a42e3256215b23958fd" => :catalina
    sha256 "2f4edc077fba5cc8f7783764f723a501db7dd66aff44d592bea61a222c00a475" => :mojave
    sha256 "d67e8cb874e3eb32dd1de53ccbbc59ffceb0d3c5c49cb43abb6fe70aaca60ded" => :high_sierra
  end

  depends_on :xcode => ["9.4", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
    bin.install ".build/release/natalie"
    share.install "NatalieExample"
  end

  test do
    generated_code = Utils.popen_read("#{bin}/natalie #{share}/NatalieExample")
    assert generated_code.lines.count > 1, "Natalie failed to generate code!"
  end
end
