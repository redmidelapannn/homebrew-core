class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "https://ccl.clozure.com"
  url "https://github.com/Clozure/ccl/archive/v1.11.6.tar.gz"
  sha256 "6a496d35e05dc3e6e7637884552b1f14c82296525546f28337b222e4c3d7d50b"
  head "https://github.com/Clozure/ccl.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a8bd36117536a10e698e02bca7e30c2dc6de344eb4d0230499cd242136e0ecbb" => :mojave
    sha256 "43f594f16eef553d2423101b04e5aee16aa6c6751d1dd95369999c58b250ef1b" => :high_sierra
    sha256 "a5f19b59c3b2a48c768eccd91d0f18933d593ce0f90927e7be9bf8af034a4969" => :sierra
  end

  depends_on :xcode => :build

  resource "bootstrap" do
    url "https://github.com/Clozure/ccl/releases/download/v1.11.5/ccl-1.11.5-darwinx86.tar.gz"
    sha256 "5adbea3d8b4a2e29af30d141f781c6613844f468c0ccfa11bae908c3e9641939"
  end

  def install
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("bootstrap")
    buildpath.install tmpdir/"dx86cl64.image"
    buildpath.install tmpdir/"darwin-x86-headers64"
    cd "lisp-kernel/darwinx8664" do
      system "make"
    end

    ENV["CCL_DEFAULT_DIRECTORY"] = buildpath

    system "./dx86cl64", "-n", "-l", "lib/x8664env.lisp",
                         "-e", "(ccl:xload-level-0)",
                         "-e", "(ccl:compile-ccl)",
                         "-e", "(quit)"
    (buildpath/"image").write('(ccl:save-application "dx86cl64.image")\n(quit)\n')
    system "cat image | ./dx86cl64 -n --image-name x86-boot64.image"

    prefix.install "doc/README"
    doc.install Dir["doc/*"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/scripts/ccl64"]
    bin.env_script_all_files(libexec/"bin", :CCL_DEFAULT_DIRECTORY => libexec)
  end

  test do
    output = shell_output("#{bin}/ccl64 -n -e '(write-line (write-to-string (* 3 7)))' -e '(quit)'")
    assert_equal "21", output.strip
  end
end
