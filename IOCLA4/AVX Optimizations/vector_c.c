/* I included the AVX header for you */
#include <immintrin.h>
#include <math.h>

void f_vector_op(float *A, float *B, float *C, float *D, int n)
{
    float sum = 0;

    /* A * B; result stored in sum */
    for (int i = 0; i < n; i++)
        sum += A[i] * B[i];

    /* Computing D */
    for (int i = 0; i < n; i++)
        D[i] = sqrt(C[i]) + sum;
}

void f_vector_op_avx(float *A, float *B, float *C, float *D, int n)
{
    float totalSum = 0;
    int remaining = n - (n / 8) * 8;

    // Compute A * B and store in totalSum as well as initialise D with sqrt(C)
    // This is done n / 8 in case n is not divisible by 8
    for (int i = 0; i < n / 8; i++) {
        // Load 8 floats from A and B into avx vector
        __m256 a = _mm256_loadu_ps(A + i * 8);
        __m256 b = _mm256_loadu_ps(B + i * 8);
        // Multiply the two vectors element by element
        __m256 mul = _mm256_mul_ps(a, b);
        // Compute the sum of result vector
        float *sum = (float*)&mul;
        for (int i = 0; i < 8; i++) {
            totalSum += sum[i];
        }
        // Load 8 floats from C into avx vector
        __m256 c = _mm256_loadu_ps(C + i * 8);
        // Compute sqrt of every element in vector
        __m256 sqrt = _mm256_sqrt_ps(c);
        // Store the results at coresponding positions in D
        _mm256_storeu_ps(D + i * 8, sqrt);
    }
    
    // If n was not divisible by 8 process remaining values
    if (remaining != 0) {
        // Load 8 floats from A and B into avx vector
        __m256 a = _mm256_loadu_ps(A + n - remaining);
        __m256 b = _mm256_loadu_ps(B + n - remaining);
        // Multiply the two vectors element by element
        __m256 mul = _mm256_mul_ps(a, b);
        // Compute the sum of result vector
        float *sum = (float*)&mul;
        for (int i = 0; i < remaining; i++) {
            totalSum += sum[i];
        }
        // Load 8 floats from C into avx vector
        __m256 c = _mm256_loadu_ps(C + n - remaining);
        // Compute sqrt of every element in vector
        __m256 sqrt = _mm256_sqrt_ps(c);
        // Store remaining number of elements
        float *res = (float*)&sqrt;
        for (int i = 0; i < remaining; i++) {
            D[i + n - remaining] = res[i];
        }
    }
    // Create an avx vector containing the result of A * B
    __m256 totalSumVector = _mm256_set1_ps(totalSum);

    // Add A * B to sqrt(C) that is already in D
    for (int i = 0; i < n / 8; i++) {
        // Load 8 floats from D into avx vector
        __m256 d = _mm256_loadu_ps(D + i * 8);
        // Add the totalSumVector
        d = _mm256_add_ps(d, totalSumVector);
        // Store the result back in D
        _mm256_storeu_ps(D + i * 8, d);
    }

    // If n was not divisible by 8 process remaining values
    if (remaining != 0) {
        // Load 8 floats from D into avx vector
        __m256 d = _mm256_loadu_ps(D + n - remaining);
        // Add the totalSumVector
        d = _mm256_add_ps(d, totalSumVector);
        // Store the remaining elements back into D
        float *res = (float*)&d;
        for (int i = 0; i < remaining; i++) {
            D[i + n - remaining] = res[i];
        }
    }
}