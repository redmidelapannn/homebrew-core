class Csound < Formula
  desc "Sound and music computing system"
  homepage "https://csound.com"
  url "https://github.com/csound/csound/archive/6.12.2.tar.gz"
  sha256 "39f4872b896eb1cbbf596fcacc0f2122fd3e5ebbb5cec14a81b4207d6b8630ff"
  revision 3

  bottle do
    sha256 "87138305ca87b346de517cbaab1edb6813826587bd58e4f3f6628477b6557f0f" => :mojave
    sha256 "1990757716db36f9204f5e1987382f8eb6922abd24c8656361fdb743d3fd8973" => :high_sierra
    sha256 "4919a3fc1ea5af926fb565f1d84e81a748efc1d913fb17320fc077ce8754d8ef" => :sierra
  end

  depends_on "cmake" => :build
  depends_on :java => [:build, :test]
  depends_on "python" => [:build, :test]
  depends_on "python@2" => [:build, :test]
  depends_on "swig" => :build
  depends_on "fltk"
  depends_on "liblo"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "numpy"
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "stk"

  conflicts_with "libextractor", :because => "both install `extract` binaries"
  conflicts_with "pkcrack", :because => "both install `extract` binaries"

  def install
    inreplace "CMakeLists.txt",
      %r{^set\(CS_FRAMEWORK_DEST\s+"~/Library/Frameworks"\)$},
      "set(CS_FRAMEWORK_DEST \"#{frameworks}\")"

    args = std_cmake_args + %W[
      -DBUILD_FLUID_OPCODES=OFF
      -DBUILD_LUA_INTERFACE=OFF
      -DBUILD_PYTHON_INTERFACE=OFF
      -DCMAKE_INSTALL_RPATH=#{frameworks}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"

      libexec.install "csnd6.jar", "lib_jcsound6.jnilib"
    end

    include.install_symlink "#{frameworks}/CsoundLib64.framework/Headers" => "csound"

    libexec.install "#{buildpath}/interfaces/ctcsound.py"

    ["python2", "python3"].each do |python|
      version = Language::Python.major_minor_version python
      (lib/"python#{version}/site-packages/homebrew-csound.pth").write <<~EOS
        import site; site.addsitedir('#{libexec}')
      EOS
    end
  end

  def caveats; <<~EOS
    To use the Python bindings, you may need to add to your .bash_profile:
      export DYLD_FRAMEWORK_PATH="$DYLD_FRAMEWORK_PATH:#{opt_prefix}/Frameworks"

    To use the Java bindings, you may need to add to your .bash_profile:
      export CLASSPATH='#{opt_prefix}/libexec/csnd6.jar:.'
    and link the native shared library into your Java Extensions folder:
      mkdir -p ~/Library/Java/Extensions
      ln -s '#{opt_prefix}/libexec/lib_jcsound6.jnilib' ~/Library/Java/Extensions
  EOS
  end

  test do
    (testpath/"test.orc").write <<~EOS
      0dbfs = 1
      FLrun
      pyinit
      instr 1
          pyruni "from __future__ import print_function; print('hello, world')"
          aSignal STKPlucked 440, 1
          out aSignal
      endin
    EOS

    (testpath/"test.sco").write <<~EOS
      i 1 0 1
      e
    EOS

    ENV["OPCODE6DIR64"] = "#{HOMEBREW_PREFIX}/Frameworks/CsoundLib64.framework/Resources/Opcodes64"
    ENV["RAWWAVE_PATH"] = "#{HOMEBREW_PREFIX}/share/stk/rawwaves"

    require "open3"
    stdout, stderr, status = Open3.capture3("#{bin}/csound test.orc test.sco")

    assert_equal true, status.success?
    assert_equal "hello, world\n", stdout
    assert_match /^rtaudio:/, stderr
    assert_match /^rtmidi:/, stderr

    ENV["DYLD_FRAMEWORK_PATH"] = "#{opt_prefix}/Frameworks"

    system "python2", "-c", "import ctcsound"
    system "python3", "-c", "import ctcsound"

    (testpath/"test.java").write <<~EOS
      import csnd6.*;
      public class test {
          public static void main(String args[]) {
              csnd6.csoundInitialize(csnd6.CSOUNDINIT_NO_ATEXIT | csnd6.CSOUNDINIT_NO_SIGNAL_HANDLER);
          }
      }
    EOS

    ENV["CLASSPATH"] = "#{opt_prefix}/libexec/csnd6.jar:."

    system "javac", "test.java"
    system "java -Djava.library.path='#{opt_prefix}/libexec' test"
  end
end
