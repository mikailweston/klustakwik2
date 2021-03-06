#cython: boundscheck=False
#cython: wraparound=False
#cython: cdivision=True
#cython: infer_types=True

import numpy
cimport numpy

def accumulate_cluster_mask_sum(kk, cluster_mask_sum):
    data = kk.data
    clusters = kk.clusters
    unmasked = data.unmasked
    ustart = data.unmasked_start
    uend = data.unmasked_end
    masks = data.masks
    vstart = data.values_start
    vend = data.values_end
    num_spikes = data.num_spikes
    doaccum(clusters, unmasked, ustart, uend, masks, vstart, vend, cluster_mask_sum)

cdef doaccum(numpy.ndarray[int, ndim=1] clusters,
             numpy.ndarray[int, ndim=1] unmasked,
             numpy.ndarray[int, ndim=1] ustart,
             numpy.ndarray[int, ndim=1] uend,
             numpy.ndarray[double, ndim=1] masks,
             numpy.ndarray[int, ndim=1] vstart,
             numpy.ndarray[int, ndim=1] vend,
             numpy.ndarray[double, ndim=2] cluster_mask_sum,
             ):
    cdef int p
    cdef int c
    cdef int num_unmasked
    for p in range(len(clusters)):
        c = clusters[p]
        if c<=1:
            continue
        num_unmasked = uend[p]-ustart[p]
        for i in range(num_unmasked):
            cluster_mask_sum[c, unmasked[ustart[p]+i]] += masks[vstart[p]+i]
