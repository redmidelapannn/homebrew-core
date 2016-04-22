
class Civl < Formula
  desc "The Concurrency Intermediate Verification Language"
  homepage "http://vsl.cis.udel.edu/civl/"
  url "http://vsl.cis.udel.edu/lib/sw/civl/1.7/r3157/release/CIVL-1.7_3157.tgz"
  sha256 "33fa5b4877fbf494b0a4b426c15d6a165fa3db48a9f97cbf391818d965d2dfb9"
  bottle do
    cellar :any_skip_relocation
    sha256 "01b33fc3cddfc95c792a983255500335fca95c997e1e9b2e83d477682723c626" => :el_capitan
    sha256 "aaf3d1d2b16017b0ebd40cc58ddbe856a748e042ab912320ed7861614841e384" => :yosemite
    sha256 "f73d7bc804ca727b4653e34025b7956f658b36eec5979a991f20780c66f716e4" => :mavericks
  end

  depends_on :java => "1.8+"
  depends_on "z3"
  depends_on "cvc4"

  def install
    libexec.install "lib/civl-1.7_3157.jar"
    bin.write_jar_script libexec/"civl-1.7_3157.jar", "civl"
    share.install "doc"
    share.install "examples"
    share.install "licenses"
    share.install "emacs"
  end
  test do
    system "#{bin}/civl"
  end
end
