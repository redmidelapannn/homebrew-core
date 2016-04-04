class Makensis < Formula
  desc "System to create Windows installers"
  homepage "http://nsis.sourceforge.net/"

  stable do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%202/2.50/nsis-2.50-src.tar.bz2"
    sha256 "3fb674cb75e0237ef6b7c9e8a8e8ce89504087a6932c5d2e26764d4220a89848"

    resource "nsis" do
      url "https://downloads.sourceforge.net/project/nsis/NSIS%202/2.50/nsis-2.50.zip"
      sha256 "36bebcd12ad8ec6b94920b46c4c5a7a9fccdaa5e9aececb9e89aecfdfa35e472"
    end
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "1a5446e576d33273d2c3176b520967309638fb37574ea0a40c434ff145882c8f" => :el_capitan
    sha256 "3386f7f715fda761125620ec15f0173175d446e38eb1eb737aabd0f379dc4985" => :yosemite
    sha256 "41aa0dd107cb751a9020979efb4f60ed12c50ecb2c840e7a963288fc3407be09" => :mavericks
  end

  devel do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203%20Pre-release/3.0rc1/nsis-3.0rc1-src.tar.bz2"
    sha256 "4e2a98c96f470386f41dcc7fd3163935228f8833d6accd0884aa0f4cb960b232"

    resource "nsis" do
      url "https://downloads.sourceforge.net/project/nsis/NSIS%203%20Pre-release/3.0rc1/nsis-3.0rc1.zip"
      sha256 "d9ae82c7ace44dd265f1081861287a5565c742448e0460386b165b54c6465694"
    end
  end

  depends_on "scons" => :build

  # scons appears to have no builtin way to override the compiler selection,
  # and the only options supported on OS X are 'gcc' and 'g++'.
  # Use the right compiler by forcibly altering the scons config to set these
  patch :DATA

  def install
    # makensis fails to build under libc++; since it's just a binary with
    # no Homebrew dependencies, we can just use libstdc++
    # https://sourceforge.net/p/nsis/bugs/1085/
    ENV.libstdcxx if ENV.compiler == :clang

    # Don't strip, see https://github.com/Homebrew/homebrew/issues/28718
    scons "STRIP=0", "SKIPUTILS=all", "makensis"

    if build.stable?
      bin.install "build/release/makensis/makensis"
    else
      bin.install "build/urelease/makensis/makensis"
    end

    (share/"nsis").install resource("nsis")
  end

  test do
    system "#{bin}/makensis", "-VERSION"
  end
end

__END__
diff --git a/SCons/config.py b/SCons/config.py
index a344456..37c575b 100755
--- a/SCons/config.py
+++ b/SCons/config.py
@@ -1,3 +1,5 @@
+import os
+
 Import('defenv')
 
 ### Configuration options
@@ -440,6 +442,9 @@ Help(cfg.GenerateHelpText(defenv))
 env = Environment()
 cfg.Update(env)
 
+defenv['CC'] = os.environ['CC']
+defenv['CXX'] = os.environ['CXX']
+
 def AddValuedDefine(define):
   defenv.Append(NSIS_CPPDEFINES = [(define, env[define])])
