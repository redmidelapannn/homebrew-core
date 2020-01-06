class Lfe < Formula
  desc "Concurrent Lisp for the Erlang VM"
  homepage "http://lfe.io/"
  url "https://github.com/rvirding/lfe/archive/v1.3.tar.gz"
  sha256 "1946c0df595ae49ac33fe583f359812dec6349da6acf43c1458534de3267036b"
  head "https://github.com/rvirding/lfe.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0a9d3537241e897decbe42c6bf25428ad6e0cfd4393b78644431f7eba82e807b" => :mojave
    sha256 "5c0482a9b11e64c473e13c77d46e036d3ffd38e13278a043eb06772bdc87bcff" => :high_sierra
  end

  depends_on "erlang"

  def install
    system "make"
    system "make", "MANINSTDIR=#{man}", "install-man"
    system "make", "emacs"
    libexec.install "bin", "ebin"
    bin.install_symlink (libexec/"bin").children
    doc.install Dir["doc/*.txt"]
    pkgshare.install "dev", "examples", "test"
    elisp.install Dir["emacs/*.elc"]
  end

  test do
    system bin/"lfe", "-eval", '"(io:format \"~p\" (list (* 2 (lists:foldl #\'+/2 0 (lists:seq 1 6)))))"'
  end
end
