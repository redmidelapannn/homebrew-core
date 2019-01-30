class Gmtl < Formula
  desc "Lightweight math library"
  homepage "https://ggt.sourceforge.io/"
  head "https://svn.code.sf.net/p/ggt/code/trunk"

  stable do
    url "https://downloads.sourceforge.net/project/ggt/Generic%20Math%20Template%20Library/0.6.1/gmtl-0.6.1.tar.gz"
    sha256 "f7d8e6958d96a326cb732a9d3692a3ff3fd7df240eb1d0921a7c5c77e37fc434"

    # Build assumes that Python is a framework, which isn't always true. See:
    # https://sourceforge.net/p/ggt/bugs/22/
    # The SConstruct from gmtl's HEAD doesn't need to be patched
    patch :DATA
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "af9d7c353a8d278758974ad445686f35b7cc2807ad434711163754e98bae2a54" => :mojave
    sha256 "af9d7c353a8d278758974ad445686f35b7cc2807ad434711163754e98bae2a54" => :high_sierra
    sha256 "0c573b61fc5d1a9dd1c1693d0aaf2e02cd29510b3e9e53e543e93feba3de71cd" => :sierra
  end

  depends_on "scons" => :build

  # The scons script in gmtl only works for gcc, patch it
  # https://sourceforge.net/p/ggt/bugs/28/
  patch do
    url "https://gist.githubusercontent.com/anonymous/c16cad998a4903e6b3a8/raw/e4669b3df0e14996c7b7b53937dd6b6c2cbc7c04/gmtl_Sconstruct.diff"
    sha256 "1167f89f52f88764080d5760b6d054036734b26c7fef474692ff82e9ead7eb3c"
  end

  def install
    system "scons", "install", "prefix=#{prefix}"
  end
end

__END__
diff --git a/SConstruct b/SConstruct
index 8326a89..2eb7ff0 100644
--- a/SConstruct
+++ b/SConstruct
@@ -126,7 +126,9 @@ def BuildDarwinEnvironment():

    exp = re.compile('^(.*)\/Python\.framework.*$')
    m = exp.search(distutils.sysconfig.get_config_var('prefix'))
-   framework_opt = '-F' + m.group(1)
+   framework_opt = None
+   if m:
+      framework_opt = '-F' + m.group(1)

    CXX = os.environ.get("CXX", WhereIs('g++'))

@@ -138,7 +140,10 @@ def BuildDarwinEnvironment():

    LINK = CXX
    CXXFLAGS = ['-ftemplate-depth-256', '-DBOOST_PYTHON_DYNAMIC_LIB',
-               '-Wall', framework_opt, '-pipe']
+               '-Wall', '-pipe']
+
+   if framework_opt is not None:
+      CXXFLAGS.append(framework_opt)

    compiler_ver       = match_obj.group(1)
    compiler_major_ver = int(match_obj.group(2))
@@ -152,7 +157,10 @@ def BuildDarwinEnvironment():
          CXXFLAGS += ['-Wno-long-double', '-no-cpp-precomp']

    SHLIBSUFFIX = distutils.sysconfig.get_config_var('SO')
-   SHLINKFLAGS = ['-bundle', framework_opt, '-framework', 'Python']
+   SHLINKFLAGS = ['-bundle']
+
+   if framework_opt is not None:
+      SHLINKFLAGS.extend([framework_opt, '-framework', 'Python'])
    LINKFLAGS = []

    # Enable profiling?
