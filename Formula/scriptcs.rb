class Scriptcs < Formula
  desc "Tools to write and execute C#"
  homepage "https://github.com/scriptcs/scriptcs"
  url "https://github.com/scriptcs/scriptcs/archive/v0.17.1.tar.gz"
  sha256 "e876118d82f52cbdd9569783ec9278c4ac449055aa628cdcb2d785bf8098a434"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eac95fa3b638238edb008ebb4c5b1547cf773bd848c86ec1160897b8e1969e2c" => :sierra
    sha256 "1daccb98d578ccdafb2f02592c3c034b0fc78f4e8eed762873bd7eb31daeee6e" => :el_capitan
    sha256 "9791d45e72c1e832da7bb87ea783e920b94363a5e58bc2529ccf44039e7bf8b9" => :yosemite
  end

  # Checks for mozroots during build, can't be only :recommended.
  depends_on "mono"

  def install
    script_file = "scriptcs.sh"
    system "sh", "./build_brew.sh"
    libexec.install Dir["src/ScriptCs/bin/Release/*"]
    (libexec/script_file).write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/scriptcs.exe $@
    EOS
    (libexec/script_file).chmod 0755
    bin.install_symlink libexec/script_file => "scriptcs"
  end

  test do
    test_file = "tests.csx"
    (testpath/test_file).write('Console.WriteLine("{0}, {1}!", "Hello", "world");')
    assert_equal "Hello, world!", shell_output("#{bin}/scriptcs #{test_file}").strip
  end
end
