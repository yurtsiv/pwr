using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MyWeaponController : MonoBehaviour
{
    public GameObject muzzleFlash;
    public float damage = 10f;

    public Camera fpsCam;

    ParticleSystem muzzleFlashParticle;
    AudioSource shootSound;

    void Start()
    {
        muzzleFlashParticle = muzzleFlash.GetComponent<ParticleSystem>();
        shootSound = GetComponent<AudioSource>();
    }

    void Update()
    {
        if (Input.GetButtonDown("Fire"))
        {
            Shoot();
        }
    }

    void Shoot()
    {
        muzzleFlashParticle.Play();
        shootSound.Play();

        RaycastHit hit;

        if (Physics.Raycast(fpsCam.transform.position, fpsCam.transform.forward, out hit))
        {

        }
    }

    public void Raycast()
    {
        
    }
}
