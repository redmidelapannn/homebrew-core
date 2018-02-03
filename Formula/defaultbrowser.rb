class Defaultbrowser < Formula
  desc "Command-line tool for getting & setting the default browser"
  homepage "https://github.com/kerma/defaultbrowser"
  url "https://github.com/kerma/defaultbrowser/archive/v1.0.tar.gz"
  sha256 "c36cc05e778233f7a3c6109ca78227f82dbdde33a5194dae1457cd83fdf27df2"
  head "https://github.com/kerma/defaultbrowser.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4198295898f3cf2f1b89a4711814b047875a7ced71b37460e3f5e7cb055aac06" => :high_sierra
    sha256 "0abaa97172831d8de67dd54b303cb6a2d930aa01f384244a5f711836915309e9" => :sierra
    sha256 "b1ec5324d1859b16e387dc6f2cb59592b28ef8b58fc7864c6df5cd43d0b3901f" => :el_capitan
  end

  def install
    if build.head?
      system "make"
      mkdir_p bin.to_s
      system "make", "install", "PREFIX=#{prefix}"
      bin.install "defaultbrowser"
    else
      xcodebuild "SYMROOT=build", "-project", "defaultbrowser.xcodeproj", "-alltargets", "-configuration", "Release"
      bin.install "build/Release/defaultbrowser"
    end
  end

  test do
    if build.head?
      # new defaultbrowser outputs a list of browsers by default;
      # safari is pretty much guaranteed to be in that list
      assert_match "safari", shell_output("#{bin}/defaultbrowser")
    else
      # old defaultbrowser outputs the current browser
      assert_match "Current:", shell_output("#{bin}/defaultbrowser")
    end
  end
end
