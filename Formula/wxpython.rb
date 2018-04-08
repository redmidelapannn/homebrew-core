class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxwidgets.org/"
  url "https://downloads.sourceforge.net/project/wxpython/wxPython/3.0.2.0/wxPython-src-3.0.2.0.tar.bz2"
  sha256 "d54129e5fbea4fb8091c87b2980760b72c22a386cb3b9dd2eebc928ef5e8df61"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "68c41c738c00fed23d3e497f9091350dc31ea6190949cb09d62f8eb6ce8b5ee5" => :high_sierra
    sha256 "d25348f1eac482edc0b8d09447dbf794c258a62eb02afa90fe63daab31c81f66" => :sierra
    sha256 "93f3044a00144aaa3630f8092b524ed6e4cfd38f32006736333a8f6e9ce33027" => :el_capitan
  end

  depends_on "python@2"
  depends_on "wxmac"

  def install
    ENV["WXWIN"] = buildpath
    ENV.append_to_cflags "-arch #{MacOS.preferred_arch}"

    # wxPython is hardcoded to install headers in wx's prefix;
    # set it to use wxPython's prefix instead
    # See #47187.
    inreplace %w[wxPython/config.py wxPython/wx/build/config.py],
      "WXPREFIX +", "'#{prefix}' +"

    args = [
      "WXPORT=osx_cocoa",
      # Reference our wx-config
      "WX_CONFIG=#{Formula["wxmac"].opt_bin}/wx-config",
      # At this time Wxmac is installed Unicode only
      "UNICODE=1",
      # Some scripts (e.g. matplotlib) expect to `import wxversion`, which is
      # only available on a multiversion build.
      "INSTALL_MULTIVERSION=1",
      # OpenGL and stuff
      "BUILD_GLCANVAS=1",
      "BUILD_GIZMOS=1",
      "BUILD_STC=1",
    ]

    cd "wxPython" do
      system "python", "setup.py", "install", "--prefix=#{prefix}", *args
    end
  end

  test do
    output = shell_output("python -c 'import wx ; print wx.version()'")
    assert_match version.to_s, output
  end
end
