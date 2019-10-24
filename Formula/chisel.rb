class Chisel < Formula
  desc "Collection of LLDB commands to assist debugging iOS apps"
  homepage "https://github.com/facebook/chisel"
  url "https://github.com/facebook/chisel/archive/1.8.1.tar.gz"
  sha256 "2f803ac99c20d2ae86d4485eb3d1be29010c5e3088ccf0a2b19021657022e3fb"
  head "https://github.com/facebook/chisel.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1f18a97143eab1946cce9ae15f38abffdf534a43791b73b723bc292dcce25cd7" => :catalina
    sha256 "0bbe17233a3aaf83fb729867438e63b0c89e83898bf2db65a3d78210344b558d" => :mojave
    sha256 "120451a055bb2ed9b7526cdb6a239df1c0b2f842e3893b29273dd3b98e9d4a8d" => :high_sierra
  end

  def install
    libexec.install Dir["*.py", "commands"]
    prefix.install "PATENTS" unless build.head?

    # == LD_DYLIB_INSTALL_NAME Explanation ==
    # This make invocation calls xcodebuild, which in turn performs ad hoc code
    # signing. Note that ad hoc code signing does not need signing identities.
    # Brew will update binaries to ensure their internal paths are usable, but
    # modifying a code signed binary will invalidate the signature. To prevent
    # broken signing, this build specifies the target install name up front,
    # in which case brew doesn't perform its modifications.
    system "make", "-C", "Chisel", "install", "PREFIX=#{lib}", \
      "LD_DYLIB_INSTALL_NAME=#{opt_prefix}/lib/Chisel.framework/Chisel"
  end

  def caveats; <<~EOS
    Add the following line to ~/.lldbinit to load chisel when Xcode launches:
      command script import #{opt_libexec}/fblldb.py
  EOS
  end

  test do
    xcode_path = `xcode-select --print-path`.strip
    lldb_rel_path = "Contents/SharedFrameworks/LLDB.framework/Resources/Python"
    ENV["PYTHONPATH"] = "#{xcode_path}/../../#{lldb_rel_path}"
    system "python", "#{libexec}/fblldb.py"
  end
end
