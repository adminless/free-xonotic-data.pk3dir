#include "effectinfo.qh"
/*qc2rust::define::EFFECTINFO_PARSER*/
#define EFFECTINFO_PARSER(on,MY) /*qc2rust::macro_begin::EFFECTINFO_PARSER*/ /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(type,                                         /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(type)     ,{ demand(n == 1 && "type");                     /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(type) = strzone(argv(1));     }, sprintf(" %s",                               ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(type))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(airfriction,                                  /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(airfriction)     ,{ demand(n == 1 && "airfriction");              /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(airfriction) = stof(argv(1));     }, sprintf(" %s",                               ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(airfriction))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(alpha,                                        /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(alpha_min) ||                     /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(alpha_max) ||                 /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(alpha_fade)     ,{ demand(n == 3 && "alpha");                    /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(alpha_min) = stof(argv(1));       /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(alpha_max) = stof(argv(2));   /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(alpha_fade) = stof(argv(3));     }, sprintf(" %s %s %s",                         ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(alpha_min)),                ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(alpha_max)),            ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(alpha_fade))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(blend,                                        /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(blend)     ,{ demand(n == 1 && "blend");                    /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(blend) = strzone(argv(1));     }, sprintf(" %s",                               ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(blend))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(bounce,                                       /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(bounce)     ,{ demand(n == 1 && "bounce");                   /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(bounce) = stof(argv(1));     }, sprintf(" %s",                               ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(bounce))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(color,                                        /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(color_min) ||                     /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(color_max)     ,{ demand(n == 2 && "color");                    /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(color_min) = strzone(argv(1));    /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(color_max) = strzone(argv(2));     }, sprintf(" %s %s",                            ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(color_min)),                    ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(color_max))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(countabsolute,                                /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(countabsolute)     ,{ demand(n == 1 && "countabsolute");            /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(countabsolute) = stof(argv(1));     }, sprintf(" %s",                               ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(countabsolute))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(count,                                        /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(count)     ,{ demand(n == 1 && "count");                    /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(count) = stof(argv(1));     }, sprintf(" %s",                               ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(count))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(gravity,                                      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(gravity)     ,{ demand(n == 1 && "gravity");                  /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(gravity) = stof(argv(1));     }, sprintf(" %s",                               ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(gravity))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(lightcolor,                                   /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lightcolor)     ,{ demand(n == 3 && "lightcolor");               /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lightcolor) = vec3(stof(argv(1)), stof(argv(2)), stof(argv(3)));     }, sprintf(" %v",                               ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lightcolor))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(lightradiusfade,                              /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lightradiusfade)     ,{ demand(n == 1 && "lightradiusfade");          /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lightradiusfade) = stof(argv(1));     }, sprintf(" %s",                               ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lightradiusfade))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(lightradius,                                  /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lightradius)     ,{ demand(n == 1 && "lightradius");              /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lightradius) = stof(argv(1));     }, sprintf(" %s",                               ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lightradius))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(lighttime,                                    /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lighttime)     ,{ demand(n == 1 && "lighttime");                /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lighttime) = stof(argv(1));     }, sprintf(" %s",                               ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lighttime))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(liquidfriction,                               /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(liquidfriction)     ,{ demand(n == 1 && "liquidfriction");           /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(liquidfriction) = stof(argv(1));     }, sprintf(" %s",                               ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(liquidfriction))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(notunderwater,                                /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(notunderwater)     ,{ demand(n == 0 && "notunderwater");            /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(notunderwater) = true;     }, ""     )      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(orientation,                                  /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(orientation)     ,{ demand(n == 1 && "orientation");              /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(orientation) = strzone(argv(1));     }, sprintf(" %s",                               ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(orientation))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(originjitter,                                 /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(originjitter)     ,{ demand(n == 3 && "originjitter");             /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(originjitter) = vec3(stof(argv(1)), stof(argv(2)), stof(argv(3)));     }, sprintf(" %v",                               ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(originjitter))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(originoffset,                                 /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(originoffset)     ,{ demand(n == 3 && "originoffset");             /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(originoffset) = vec3(stof(argv(1)), stof(argv(2)), stof(argv(3)));     }, sprintf(" %v",                               ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(originoffset))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(relativeoriginoffset,                         /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(relativeoriginoffset)     ,{ demand(n == 3 && "relativeoriginoffset");     /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(relativeoriginoffset) = vec3(stof(argv(1)), stof(argv(2)), stof(argv(3)));     }, sprintf(" %v",                               ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(relativeoriginoffset))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(relativevelocityoffset,                       /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(relativevelocityoffset)     ,{ demand(n == 3 && "relativevelocityoffset");   /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(relativevelocityoffset) = vec3(stof(argv(1)), stof(argv(2)), stof(argv(3)));     }, sprintf(" %v",                               ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(relativevelocityoffset))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(rotate,                                       /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(startangle_min) ||                /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(startangle_max) ||                /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(spin_min) ||                  /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(spin_max)     ,{ demand(n == 4 && "rotate");                   /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(startangle_min) = stof(argv(1));  /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(startangle_max) = stof(argv(2));  /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(spin_min) = stof(argv(3));    /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(spin_max) = stof(argv(4));     }, sprintf(" %s %s %s %s",                      ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(startangle_min)),           ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(startangle_max)),           ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(spin_min)),             ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(spin_max))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(sizeincrease,                                 /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(sizeincrease)     ,{ demand(n == 1 && "sizeincrease");             /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(sizeincrease) = stof(argv(1));     }, sprintf(" %s",                               ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(sizeincrease))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(size,                                         /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(size_min) ||                      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(size_max)     ,{ demand(n == 2 && "size");                     /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(size_min) = stof(argv(1));        /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(size_max) = stof(argv(2));     }, sprintf(" %s %s",                            ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(size_min)),                 ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(size_max))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(staincolor,                                   /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staincolor_min) ||                    /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staincolor_max)     ,{ demand(n == 2 && "staincolor");               /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staincolor_min) = strzone(argv(1));   /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staincolor_max) = strzone(argv(2));     }, sprintf(" %s %s",                            ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staincolor_min)),                   ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staincolor_max))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(stainsize,                                    /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(stainsize_min) ||                 /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(stainsize_max)     ,{ demand(n == 2 && "stainsize");                /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(stainsize_min) = stof(argv(1));   /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(stainsize_max) = stof(argv(2));     }, sprintf(" %s %s",                            ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(stainsize_min)),            ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(stainsize_max))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(staintex,                                     /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staintex_min) ||                  /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staintex_max)     ,{ demand(n == 2 && "staintex");                 /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staintex_min) = stof(argv(1));    /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staintex_max) = stof(argv(2));     }, sprintf(" %s %s",                            ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staintex_min)),             ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staintex_max))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(stretchfactor,                                /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(stretchfactor)     ,{ demand(n == 1 && "stretchfactor");            /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(stretchfactor) = stof(argv(1));     }, sprintf(" %s",                               ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(stretchfactor))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(tex,                                          /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(tex_min) ||                       /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(tex_max)     ,{ demand(n == 2 && "tex");                      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(tex_min) = stof(argv(1));         /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(tex_max) = stof(argv(2));     }, sprintf(" %s %s",                            ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(tex_min)),                  ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(tex_max))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(time,                                         /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(time_min) ||                      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(time_max)     ,{ demand(n == 2 && "time");                     /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(time_min) = stof(argv(1));        /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(time_max) = stof(argv(2));     }, sprintf(" %s %s",                            ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(time_min)),                 ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(time_max))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(trailspacing,                                 /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(trailspacing)     ,{ demand(n == 1 && "trailspacing");             /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(trailspacing) = stof(argv(1));     }, sprintf(" %s",                               ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(trailspacing))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(underwater,                                   /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(underwater)     ,{ demand(n == 0 && "underwater");               /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(underwater) = true;     }, ""     )      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(velocityjitter,                               /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(velocityjitter)     ,{ demand(n == 3 && "velocityjitter");           /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(velocityjitter) = vec3(stof(argv(1)), stof(argv(2)), stof(argv(3)));     }, sprintf(" %v",                               ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(velocityjitter))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(velocitymultiplier,                           /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(velocitymultiplier)     ,{ demand(n == 1 && "velocitymultiplier");       /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(velocitymultiplier) = stof(argv(1));     }, sprintf(" %s",                               ftos( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(velocitymultiplier))     ))      /*qc2rust::param_begin::on*/on /*qc2rust::param_end::on*/(velocityoffset,                               /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(velocityoffset)     ,{ demand(n == 3 && "velocityoffset");           /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(velocityoffset) = vec3(stof(argv(1)), stof(argv(2)), stof(argv(3)));     }, sprintf(" %v",                               ( /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(velocityoffset))     ))     /**/ /*qc2rust::macro_end::EFFECTINFO_PARSER*/

CLASS(EffectInfo, Object)
    ATTRIB(EffectInfo, effectinfo_name, string);
    CONSTRUCTOR(EffectInfo, string s) {
        CONSTRUCT(EffectInfo);
        this.effectinfo_name = s;
    }

/*qc2rust::define::FIELDS*/
#define FIELDS(MY) /*qc2rust::macro_begin::FIELDS*/ /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(airfriction, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(alpha_min, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(alpha_max, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(alpha_fade, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(blend, string, string_null)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(bounce, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(color_min, string, string_null)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(color_max, string, string_null)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(countabsolute, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(count, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(gravity, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lightcolor, vector, '0 0 0')      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lightradiusfade, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lightradius, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(lighttime, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(liquidfriction, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(notunderwater, bool, false)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(orientation, string, string_null)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(originjitter, vector, '0 0 0')      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(originoffset, vector, '0 0 0')      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(relativeoriginoffset, vector, '0 0 0')      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(relativevelocityoffset, vector, '0 0 0')      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(startangle_min, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(startangle_max, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(spin_min, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(spin_max, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(sizeincrease, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(size_min, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(size_max, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staincolor_min, string, string_null)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staincolor_max, string, string_null)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(stainsize_min, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(stainsize_max, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staintex_min, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(staintex_max, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(stretchfactor, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(tex_min, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(tex_max, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(time_min, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(time_max, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(trailspacing, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(type, string, string_null)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(underwater, bool, false)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(velocityjitter, vector, '0 0 0')      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(velocitymultiplier, float, 0)      /*qc2rust::param_begin::MY*/MY /*qc2rust::param_end::MY*/(velocityoffset, vector, '0 0 0')     /**/ /*qc2rust::macro_end::FIELDS*/

    #define MY(f, type, val) ATTRIB(EffectInfo, effectinfo_##f, type, val);
    FIELDS(MY)
    #undef MY

    METHOD(EffectInfo, describe, string(EffectInfo this))
    {
        TC(EffectInfo, this);
        string s = sprintf("SUB(%s) {\n", this.effectinfo_name);
/*qc2rust::define::str_bool*/
#define str_bool(it) /*qc2rust::macro_begin::str_bool*/( /*qc2rust::param_begin::it*/it /*qc2rust::param_end::it*/ ? "true" : "false") /*qc2rust::macro_end::str_bool*/
/*qc2rust::define::str_float*/
#define str_float(it) /*qc2rust::macro_begin::str_float*/ftos( /*qc2rust::param_begin::it*/it /*qc2rust::param_end::it*/) /*qc2rust::macro_end::str_float*/
/*qc2rust::define::str_vector*/
#define str_vector(it) /*qc2rust::macro_begin::str_vector*/vtos( /*qc2rust::param_begin::it*/it /*qc2rust::param_end::it*/) /*qc2rust::macro_end::str_vector*/
/*qc2rust::define::str_string*/
#define str_string(it) /*qc2rust::macro_begin::str_string*/strcat("\"",  /*qc2rust::param_begin::it*/it /*qc2rust::param_end::it*/, "\"") /*qc2rust::macro_end::str_string*/
        #define p(f, type, default) if (this.effectinfo_##f) { s = strcat(s, "\t", "MY("#f") = ", str_##type(this.effectinfo_##f), ";\n"); }
        FIELDS(p)
        #undef p
        return strcat(s, "}\n");
    }

    METHOD(EffectInfo, dump, string(EffectInfo this))
    {
        TC(EffectInfo, this);
        string s = sprintf("effect %s\n", this.effectinfo_name);
        #define MY(f) this.effectinfo_##f
/*qc2rust::define::p*/
#define p(k,isset,parse,unparse) /*qc2rust::macro_begin::p*/if ( /*qc2rust::param_begin::isset*/isset /*qc2rust::param_end::isset*/) { s = strcat(s, "\t",  /*qc2rust::stringify_begin::k*/#k /*qc2rust::stringify_end::k*/,  /*qc2rust::param_begin::unparse*/unparse /*qc2rust::param_end::unparse*/, "\n"); } /*qc2rust::macro_end::p*/
        EFFECTINFO_PARSER(p, MY)
        #undef p
        #undef MY
        return s;
    }

    #undef FIELDS
ENDCLASS(EffectInfo)

CLASS(EffectInfoGroup, Object)
    ATTRIBARRAY(EffectInfoGroup, children, EffectInfo, 16);
    ATTRIB(EffectInfoGroup, children_count, int, 0);
ENDCLASS(EffectInfoGroup)

void effectinfo_read()
{
    int fh = fopen("effectinfo.txt", FILE_READ);
    EffectInfo info = NULL;
    for (string line; (line = fgets(fh)); ) {
        int n = tokenize_console(line);
        if (n == 0) continue;
        n--;
        string k = argv(0);
        if (k == "effect") {
            demand(n == 1);
            info = NEW(EffectInfo, strzone(argv(1)));
            continue;
        }
        demand(info != NULL);
        switch (k) {
            #define MY(f) info.effectinfo_##f
/*qc2rust::define::p*/
#define p(k,isset,parse,unparse) /*qc2rust::macro_begin::p*/case  /*qc2rust::stringify_begin::k*/#k /*qc2rust::stringify_end::k*/:  /*qc2rust::param_begin::parse*/parse /*qc2rust::param_end::parse*/ break; /*qc2rust::macro_end::p*/
            EFFECTINFO_PARSER(p, MY)
            #undef p
            #undef MY
            default:
                LOG_WARNF("Unknown property '%s'", k);
                break;
        }
    }
    fclose(fh);
}

void effectinfo_dump(int fh, bool alsoprint)
{
/*qc2rust::define::WRITE*/
#define WRITE(str) /*qc2rust::macro_begin::WRITE*/write_String_To_File(fh,  /*qc2rust::param_begin::str*/str /*qc2rust::param_end::str*/, alsoprint) /*qc2rust::macro_end::WRITE*/
	WRITE(
		"// ********************************************** //\n"
		"// ** WARNING - DO NOT MANUALLY EDIT THIS FILE ** //\n"
		"// **                                          ** //\n"
		"// **  This file is automatically generated by ** //\n"
		"// **  code with the command 'dumpeffectinfo'. ** //\n"
		"// **                                          ** //\n"
		"// **  If you modify an effect, please         ** //\n"
		"// **  regenerate this file with that command. ** //\n"
		"// **                                          ** //\n"
		"// ********************************************** //\n"
		"\n");

    for (EffectInfo it = NULL; (it = findfloat(it, instanceOfEffectInfo, true)); ) {
        if (it.classname == "vtbl") continue;
        string s = it.dump(it);
        WRITE(s);
    }
    #undef WRITE
}

GENERIC_COMMAND(dumpeffectinfo, "Dump all effectinfo to effectinfo_dump.txt")
{
    switch (request) {
        case CMD_REQUEST_COMMAND: {
            string filename = argv(1);
			bool alsoprint = false;
            if (filename == "") {
                filename = "effectinfo_dump.txt";
                alsoprint = false;
            } else if (filename == "-") {
                filename = "effectinfo_dump.txt";
                alsoprint = true;
            }
            int fh = fopen(filename, FILE_WRITE);
            if (fh >= 0) {
            	effectinfo_dump(fh, alsoprint);
                LOG_INFOF("Dumping effectinfo... File located at ^2data/data/%s^7.", filename);
				LOG_INFOF("Reload with ^2cl_particles_reloadeffects data/%s^7.", filename);
                fclose(fh);
            } else {
                LOG_WARNF("Could not open file '%s'!", filename);
            }
            return;
        }
        default:
        case CMD_REQUEST_USAGE: {
            LOG_INFO("Usage:^3 ", GetProgramCommandPrefix(), " dumpeffectinfo [filename]");
            LOG_INFO("  Where 'filename' is the file to write (default is effectinfo_dump.txt),");
            LOG_INFO("  if supplied with '-' output to console as well as default,");
            LOG_INFO("  if left blank, it will only write to default.");
            return;
        }
    }
}


REGISTRY(EffectInfos, BITS(9))
/*qc2rust::define::EffectInfos_from*/
#define EffectInfos_from(i) /*qc2rust::macro_begin::EffectInfos_from*/_EffectInfos_from( /*qc2rust::param_begin::i*/i /*qc2rust::param_end::i*/, NULL) /*qc2rust::macro_end::EffectInfos_from*/
REGISTER_REGISTRY(EffectInfos)
#define EFFECTINFO(name)     ACCUMULATE void effectinfo_##name(EffectInfoGroup parent, EffectInfo this) { }     REGISTER(EffectInfos, EFFECTINFO, name, m_id, NEW(EffectInfoGroup)) {         effectinfo_##name(this, NULL);     }

#define MY(f) this.effectinfo_##f
/*qc2rust::define::DEF*/
#define DEF(name) /*qc2rust::macro_begin::DEF*/EFFECTINFO( /*qc2rust::param_begin::name*/name /*qc2rust::param_end::name*/) /*qc2rust::macro_end::DEF*/
#define SUB(name)     ACCUMULATE void effectinfo_##name(EffectInfoGroup parent, EffectInfo this) { parent = EFFECTINFO_##name; parent.children[parent.children_count++] = this = NEW(EffectInfo, #name); }     ACCUMULATE void effectinfo_##name(EffectInfoGroup parent, EffectInfo this)
#include "effectinfo.inc"
#undef MY
#undef DEF
#undef SUB
