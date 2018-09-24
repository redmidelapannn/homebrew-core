class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/releases/download/nlopt-2.4.2/nlopt-2.4.2.tar.gz"
  sha256 "8099633de9d71cbc06cd435da993eb424bbcdbded8f803cdaa9fb8c6e09c8e89"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "7d62809a64eacacfa93e5bfb61948046105e819fae7b3668225feee5f25cb13f" => :mojave
    sha256 "e7bc36472fed51f4deeae00239482182e446192bcdd1f5c6842e89f2b9952036" => :high_sierra
    sha256 "763089b77a961abc0b00effda100fd85cc6a24460475c1c7454ca901e9f0dacd" => :sierra
  end

  head do
    url "https://github.com/stevengj/nlopt.git"
    depends_on "cmake" => :build
    depends_on "swig" => :build
  end

  depends_on "numpy" => :recommended

  def install
    ENV.deparallelize

    if build.head?
      system "cmake", ".", *std_cmake_args,
                      "-DBUILD_MATLAB=OFF",
                      "-DBUILD_OCTAVE=OFF",
                      "-DWITH_CXX=ON"
    else
      system "./configure", "--prefix=#{prefix}",
                            "--enable-shared",
                            "--with-cxx",
                            "--without-octave"
      system "make"
    end
    system "make", "install"

    # Create library links for C programs
    %w[0.dylib dylib a].each do |suffix|
      lib.install_symlink "#{lib}/libnlopt_cxx.#{suffix}" => "#{lib}/libnlopt.#{suffix}"
    end
  end

  test do
    # Based on http://ab-initio.mit.edu/wiki/index.php/NLopt_Tutorial#Example_in_C.2FC.2B.2B
    (testpath/"test.c").write <<~EOS
      #include <math.h>
      #include <nlopt.h>
      #include <stdio.h>
      double myfunc(unsigned n, const double *x, double *grad, void *my_func_data) {
        if (grad) {
          grad[0] = 0.0;
          grad[1] = 0.5 / sqrt(x[1]);
        }
        return sqrt(x[1]);
      }
      typedef struct { double a, b; } my_constraint_data;
      double myconstraint(unsigned n, const double *x, double *grad, void *data) {
        my_constraint_data *d = (my_constraint_data *) data;
        double a = d->a, b = d->b;
        if (grad) {
          grad[0] = 3 * a * (a*x[0] + b) * (a*x[0] + b);
          grad[1] = -1.0;
        }
        return ((a*x[0] + b) * (a*x[0] + b) * (a*x[0] + b) - x[1]);
       }
       int main() {
        double lb[2] = { -HUGE_VAL, 0 }; /* lower bounds */
        nlopt_opt opt;
        opt = nlopt_create(NLOPT_LD_MMA, 2); /* algorithm and dimensionality */
        nlopt_set_lower_bounds(opt, lb);
        nlopt_set_min_objective(opt, myfunc, NULL);
        my_constraint_data data[2] = { {2,0}, {-1,1} };
        nlopt_add_inequality_constraint(opt, myconstraint, &data[0], 1e-8);
        nlopt_add_inequality_constraint(opt, myconstraint, &data[1], 1e-8);
        nlopt_set_xtol_rel(opt, 1e-4);
        double x[2] = { 1.234, 5.678 };  /* some initial guess */
        double minf; /* the minimum objective value, upon return */

        if (nlopt_optimize(opt, x, &minf) < 0)
          return 1;
        else
          printf("found minimum at f(%g,%g) = %0.10g", x[0], x[1], minf);
        nlopt_destroy(opt);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{opt_lib}", "-lnlopt", "-lm"
    assert_match "found minimum", shell_output("./test")
  end
end
