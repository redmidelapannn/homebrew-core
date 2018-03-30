class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.8.2.tar.gz"
  sha256 "86b8700c3d0880c2b44c2ff67ce42774aaf8c28cbf57725cb881569288c1c6f4"
  head "https://github.com/ninja-build/ninja.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "44571b6151b8d6b180fa86594ec68418209b9e6913eef0f6cc557c20dab17773" => :high_sierra
    sha256 "f24186bcfd0f82b7ddba3332d2691705d75f7fc4a0bd7fb2d1b24a1a0a739339" => :sierra
    sha256 "4812a67283336339a599c0e4a4805f3369291ef76dbbe3ac21d0295983e95f69" => :el_capitan
  end

  option "without-test", "Don't run build-time tests"

  deprecated_option "without-tests" => "without-test"

  def install
    system "python", "configure.py", "--bootstrap"

    if build.with? "test"
      system "./configure.py"
      system "./ninja", "ninja_test"
      system "./ninja_test", "--gtest_filter=-SubprocessTest.SetWithLots"
    end

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
  end

  test do
    (testpath/"build.ninja").write <<~EOS
      cflags = -Wall

      rule cc
        command = gcc $cflags -c $in -o $out

      build foo.o: cc foo.c
    EOS
    system bin/"ninja", "-t", "targets"
  end
end
