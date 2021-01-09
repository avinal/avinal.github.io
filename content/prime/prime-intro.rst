*****************************
Introduction to Prime Numbers
*****************************

:date: 2021-01-09 22:29
:tags: prime, primenumbers
:category: prime
:slug: prime1

.. epigraph::

    A prime is a positive integer *p* having exactly two positive divisors, namely *1* and *p*. An integer *n* is composite if *n* > *1* and *n* is not prime. (The number 1 is considered neither prime nor composite.)

We can frame a brute force algorithm for checking primality of numbers using the above statement.

.. code-block:: cpp

    bool is_prime(int number) {
        int factor = 0;
        for (int i = 0; i <= number; ++i) {
            if (number % i == 0) {
                factor++;
            }
        }
        return (factor == 2)? true : false;
    }

