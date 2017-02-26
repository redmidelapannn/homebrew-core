class FrameworkPythonRequirement < Requirement
  fatal true

  satisfy do
    q = `python -c "import distutils.sysconfig as c; print(c.get_config_var('PYTHONFRAMEWORK'))"`
    !q.chomp.empty?
  end

  def message
    "Python needs to be built as a framework."
  end
end

class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxwidgets.org/"
  url "https://downloads.sourceforge.net/project/wxpython/wxPython/3.0.2.0/wxPython-src-3.0.2.0.tar.bz2"
  sha256 "d54129e5fbea4fb8091c87b2980760b72c22a386cb3b9dd2eebc928ef5e8df61"

  bottle do
    cellar :any
    rebuild 2
    sha256 "7acce3d6100e2bddaae754da330cc660f211931f615bfd37ac5215e32f6e2237" => :sierra
    sha256 "fdeaff1a16c32efa9300a00cc8e2d23b08d2223ae247f54b93ba10470db8c787" => :el_capitan
    sha256 "6b0e7331efb291158b5f59a39f39b398ea3925e88c98d0fb5a8906046efa44dd" => :yosemite
  end

  if MacOS.version <= :snow_leopard
    depends_on :python
    depends_on FrameworkPythonRequirement
  end
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
