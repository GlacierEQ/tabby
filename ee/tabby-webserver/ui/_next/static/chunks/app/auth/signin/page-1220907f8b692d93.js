(self.webpackChunk_N_E=self.webpackChunk_N_E||[]).push([[8098],{76846:function(e,t,r){Promise.resolve().then(r.bind(r,42641))},42641:function(e,t,r){"use strict";r.r(t),r.d(t,{default:function(){return T}});var n=r(57437),s=r(2265),a=r(24033),i=r(19567),l=r(61396),o=r.n(l),c=r(93023),d=r(84168),u=r(38110),m=r(61865),f=r(74578),x=r(61985),h=r(46591),p=r(7820),v=r(41315),g=r(51908);let j=(0,h.B)("\n  mutation requestPasswordResetEmail($input: RequestPasswordResetEmailInput!) {\n    requestPasswordResetEmail(input: $input)\n  }\n"),N=f.Ry({email:f.Z_().email("Invalid email address")}),b=e=>{let{onSuccess:t}=e,r=(0,m.cI)({resolver:(0,u.F)(N)}),{isSubmitting:s}=r.formState,a=(0,p.D)(j,{form:r});return(0,n.jsx)(v.l0,{...r,children:(0,n.jsxs)("div",{className:"grid gap-2",children:[(0,n.jsxs)("form",{className:"grid gap-4",onSubmit:r.handleSubmit(e=>a({input:e}).then(r=>{var n;(null==r?void 0:null===(n=r.data)||void 0===n?void 0:n.requestPasswordResetEmail)&&(null==t||t(e.email))})),children:[(0,n.jsx)(v.Wi,{control:r.control,name:"email",render:e=>{let{field:t}=e;return(0,n.jsxs)(v.xJ,{children:[(0,n.jsx)(v.lX,{children:"Email"}),(0,n.jsx)(v.NI,{children:(0,n.jsx)(g.I,{placeholder:x.o,type:"email",autoCapitalize:"none",autoComplete:"email",autoCorrect:"off",...t})}),(0,n.jsx)(v.zG,{})]})}}),(0,n.jsxs)(c.z,{type:"submit",className:"mt-2",children:[s&&(0,n.jsx)(d.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"}),"Send Email"]})]}),(0,n.jsx)(v.zG,{className:"text-center"})]})})};function y(){let[e,t]=s.useState(),[r,a]=s.useState(!1);return r?(0,n.jsx)("div",{className:"w-[350px] space-y-6",children:(0,n.jsxs)("div",{className:"flex flex-col space-y-2 text-center",children:[(0,n.jsx)("div",{className:"flex justify-center",children:(0,n.jsx)(d.IconCheckCircled,{className:"h-12 w-12 text-successful-foreground"})}),(0,n.jsx)("h1",{className:"text-2xl font-semibold tracking-tight",children:"Reset Password"}),(0,n.jsxs)("p",{className:"pb-4 text-sm text-muted-foreground",children:["Request received successfully! If the email"," ",(0,n.jsx)("span",{className:"font-bold",children:null!=e?e:""})," exists, you’ll receive an email with a reset link soon."]}),(0,n.jsx)(o(),{href:"/auth/signin",className:(0,c.d)(),children:"Back to Sign In"})]})}):(0,n.jsxs)("div",{className:"w-[350px] space-y-6",children:[(0,n.jsxs)("div",{className:"flex flex-col space-y-2 text-center",children:[(0,n.jsx)("h1",{className:"text-2xl font-semibold tracking-tight",children:"Reset Password"}),(0,n.jsx)("p",{className:"text-sm text-muted-foreground",children:"Enter your email address. If an account exists, you’ll receive an email with a password reset link soon."})]}),(0,n.jsx)(b,{onSuccess:e=>{t(e),a(!0)}}),(0,n.jsx)("div",{className:"text-center",children:(0,n.jsx)(o(),{href:"/auth/signin",replace:!0,className:"text-primary hover:underline",children:"Cancel"})})]})}let w=(0,h.B)("\n  mutation requestInvitationEmail($input: RequestInvitationInput!) {\n    requestInvitationEmail(input: $input) {\n      email\n      code\n    }\n  }\n"),I=f.Ry({email:f.Z_().email("Invalid email address")}),S=e=>{let{onSuccess:t}=e,r=(0,m.cI)({resolver:(0,u.F)(I)}),{isSubmitting:s}=r.formState,a=(0,p.D)(w,{form:r});return(0,n.jsx)(v.l0,{...r,children:(0,n.jsxs)("div",{className:"grid gap-2",children:[(0,n.jsxs)("form",{className:"grid gap-4",onSubmit:r.handleSubmit(e=>a({input:e}).then(e=>{var r,n;(null==e?void 0:null===(n=e.data)||void 0===n?void 0:null===(r=n.requestInvitationEmail)||void 0===r?void 0:r.code)&&(null==t||t(e.data.requestInvitationEmail))})),children:[(0,n.jsx)(v.Wi,{control:r.control,name:"email",render:e=>{let{field:t}=e;return(0,n.jsxs)(v.xJ,{children:[(0,n.jsx)(v.lX,{children:"Email"}),(0,n.jsx)(v.NI,{children:(0,n.jsx)(g.I,{placeholder:x.o,type:"email",autoCapitalize:"none",autoComplete:"email",autoCorrect:"off",...t})}),(0,n.jsx)(v.zG,{})]})}}),(0,n.jsxs)(c.z,{type:"submit",className:"mt-2",children:[s&&(0,n.jsx)(d.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"}),"Send Email"]})]}),(0,n.jsx)(v.zG,{className:"text-center"})]})})};function k(){let[e,t]=s.useState(),[r,a]=s.useState(!1);return r?(0,n.jsx)("div",{className:"w-[350px] space-y-6",children:(0,n.jsxs)("div",{className:"flex flex-col space-y-2 text-center",children:[(0,n.jsx)("div",{className:"flex justify-center",children:(0,n.jsx)(d.IconCheckCircled,{className:"h-12 w-12 text-successful-foreground"})}),(0,n.jsx)("h1",{className:"text-2xl font-semibold tracking-tight",children:"Create your Tabby account"}),(0,n.jsx)("p",{className:"pb-4 text-sm text-muted-foreground",children:"Request received successfully! You’ll receive an email with a signup link soon."}),(0,n.jsx)(o(),{href:"/auth/signin",className:(0,c.d)(),children:"Back to Sign In"})]})}):(0,n.jsxs)("div",{className:"w-[350px] space-y-6",children:[(0,n.jsxs)("div",{className:"flex flex-col space-y-2 text-center",children:[(0,n.jsx)("h1",{className:"text-2xl font-semibold tracking-tight",children:"Create your Tabby account"}),(0,n.jsx)("p",{className:"text-sm text-muted-foreground",children:"To register your account, please enter your email address."})]}),(0,n.jsx)(S,{onSuccess:e=>{t(e.email),a(!0)}}),(0,n.jsxs)("div",{className:"text-center text-sm",children:["Already have an accout?",(0,n.jsx)(o(),{href:"/auth/signin",className:"ml-1 font-semibold text-primary hover:underline",children:"Sign In"})]})]})}var R=r(1589),E=r(52485),C=r(58001),z=r(1592),F=r(60106),P=r(39311);let _=(0,F.BX)("\n  mutation tokenAuth($email: String!, $password: String!) {\n    tokenAuth(email: $email, password: $password) {\n      accessToken\n      refreshToken\n    }\n  }\n"),q=f.Ry({email:f.Z_().email("Invalid email address"),password:f.Z_()});function G(e){let{className:t,invitationCode:r,...l}=e,f=(0,i.Uw)(),h=(0,m.cI)({resolver:(0,u.F)(q)}),j=(0,a.useRouter)(),{status:N}=(0,C.kP)();s.useEffect(()=>{"authenticated"===N&&j.replace("/")},[N]);let b=(0,C.zq)(),{isSubmitting:y}=h.formState,w=(0,p.D)(_,{onCompleted(e){b(e.tokenAuth)},form:h});return(0,n.jsx)(v.l0,{...h,children:(0,n.jsxs)("div",{className:(0,P.cn)("grid gap-2",t),...l,children:[(0,n.jsxs)("form",{className:"grid gap-4",onSubmit:h.handleSubmit(w),children:[(0,n.jsx)(v.Wi,{control:h.control,name:"email",render:e=>{let{field:t}=e;return(0,n.jsxs)(v.xJ,{children:[(0,n.jsx)(v.lX,{children:"Email"}),(0,n.jsx)(v.NI,{children:(0,n.jsx)(g.I,{placeholder:x.o,type:"email",autoCapitalize:"none",autoComplete:"email",autoCorrect:"off",...t})}),(0,n.jsx)(v.zG,{})]})}}),(0,n.jsx)(v.Wi,{control:h.control,name:"password",render:e=>{let{field:t}=e;return(0,n.jsxs)(v.xJ,{children:[(0,n.jsxs)("div",{className:"flex items-center justify-between",children:[(0,n.jsx)(v.lX,{children:"Password"}),!!f&&(0,n.jsx)("div",{className:"cursor-pointer text-right text-sm text-primary hover:underline",children:(0,n.jsx)(o(),{href:"/auth/signin?mode=reset",children:"Forgot password?"})})]}),(0,n.jsx)(v.NI,{children:(0,n.jsx)(g.I,{type:"password",...t})}),(0,n.jsx)(v.zG,{})]})}}),(0,n.jsxs)(c.z,{type:"submit",className:"mt-2",disabled:y,children:[y&&(0,n.jsx)(d.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"}),"Sign In"]})]}),(0,n.jsx)(v.zG,{className:"text-center"})]})})}function Z(){let{router:e,searchParams:t}=(0,E.Z)(),r=(0,i.jJ)(),a=t.get("error_message"),l=t.get("access_token"),c=t.get("refresh_token"),u=!!l&&!!c,m=u&&!a,f=(0,C.zq)(),{data:x}=(0,R.Z)(u?null:"/oauth/providers",z.Z);return((0,s.useEffect)(()=>{!a&&l&&c&&f({accessToken:l,refreshToken:c}).then(()=>e.replace("/"))},[t]),m)?(0,n.jsx)(d.IconSpinner,{className:"h-8 w-8 animate-spin"}):(0,n.jsxs)(n.Fragment,{children:[(0,n.jsxs)("div",{className:"w-[350px] space-y-6",children:[(0,n.jsxs)("div",{className:"flex flex-col space-y-2 text-center",children:[(0,n.jsx)("h1",{className:"text-2xl font-semibold tracking-tight",children:"Sign In"}),(0,n.jsx)("p",{className:"text-sm text-muted-foreground",children:"Enter credentials to login to your account"})]}),(0,n.jsx)(G,{}),r&&(0,n.jsxs)("div",{className:"text-center text-sm",children:["Don’t have an accout?",(0,n.jsx)(o(),{href:"/auth/signin?mode=signup",className:"ml-1 font-semibold text-primary hover:underline",children:"Create an account"})]})]}),!!(null==x?void 0:x.length)&&(0,n.jsxs)("div",{className:"relative mt-4 flex w-[350px] items-center py-5",children:[(0,n.jsx)("div",{className:"grow border-t "}),(0,n.jsx)("span",{className:"mx-4 shrink text-sm text-muted-foreground",children:"Or Sign In with"}),(0,n.jsx)("div",{className:"grow border-t "})]}),(0,n.jsxs)("div",{className:"mx-auto flex items-center gap-6",children:[(null==x?void 0:x.includes("github"))&&(0,n.jsx)("a",{href:"/oauth/signin?provider=github",children:(0,n.jsx)(d.IconGithub,{className:"h-8 w-8"})}),(null==x?void 0:x.includes("google"))&&(0,n.jsx)("a",{href:"/oauth/signin?provider=google",children:(0,n.jsx)(d.IconGoogle,{className:"h-8 w-8"})})]}),!!a&&(0,n.jsx)("div",{className:"mt-4 text-destructive",children:a})]})}function T(){var e;let t=(0,a.useRouter)(),r=(0,a.useSearchParams)(),l=null===(e=r.get("mode"))||void 0===e?void 0:e.toString(),o=(0,i.Uw)(),c=(0,i.jJ)();return(s.useEffect(()=>{let e=!1===o&&"reset"===l||!1===c&&"signup"===l;e&&t.replace("/auth/signin")},[l,o,c]),"reset"===l)?(0,n.jsx)(y,{}):"signup"===l?(0,n.jsx)(k,{}):(0,n.jsx)(Z,{})}},93023:function(e,t,r){"use strict";r.d(t,{d:function(){return o},z:function(){return c}});var n=r(57437),s=r(2265),a=r(67256),i=r(7404),l=r(39311);let o=(0,i.j)("inline-flex items-center justify-center rounded-md text-sm font-medium shadow ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",{variants:{variant:{default:"bg-primary text-primary-foreground shadow-md hover:bg-primary/90",destructive:"bg-destructive text-destructive-foreground hover:bg-destructive/90","hover-destructive":"shadow-none hover:bg-destructive/90 hover:text-destructive-foreground",outline:"border border-input hover:bg-accent hover:text-accent-foreground",secondary:"bg-secondary text-secondary-foreground hover:bg-secondary/80",ghost:"shadow-none hover:bg-accent hover:text-accent-foreground",link:"text-primary underline-offset-4 shadow-none hover:underline"},size:{default:"h-8 px-4 py-2",sm:"h-8 rounded-md px-3",lg:"h-11 rounded-md px-8",icon:"h-8 w-8 p-0"}},defaultVariants:{variant:"default",size:"default"}}),c=s.forwardRef((e,t)=>{let{className:r,variant:s,size:i,asChild:c=!1,...d}=e,u=c?a.g7:"button";return(0,n.jsx)(u,{className:(0,l.cn)(o({variant:s,size:i,className:r})),ref:t,...d})});c.displayName="Button"},41315:function(e,t,r){"use strict";r.d(t,{NI:function(){return p},Wi:function(){return u},l0:function(){return c},lX:function(){return h},pf:function(){return v},xJ:function(){return x},zG:function(){return g}});var n=r(57437),s=r(2265),a=r(67256),i=r(61865),l=r(39311),o=r(66672);let c=i.RV,d=s.createContext({}),u=e=>{let{...t}=e;return(0,n.jsx)(d.Provider,{value:{name:t.name},children:(0,n.jsx)(i.Qr,{...t})})},m=()=>{let e=s.useContext(d),t=s.useContext(f),{getFieldState:r,formState:n}=(0,i.Gc)(),a=e.name||"root",l=r(a,n);if(!n)throw Error("useFormField should be used within <Form>");let{id:o}=t;return{id:o,name:a,formItemId:"".concat(o,"-form-item"),formDescriptionId:"".concat(o,"-form-item-description"),formMessageId:"".concat(o,"-form-item-message"),...l}},f=s.createContext({}),x=s.forwardRef((e,t)=>{let{className:r,...a}=e,i=s.useId();return(0,n.jsx)(f.Provider,{value:{id:i},children:(0,n.jsx)("div",{ref:t,className:(0,l.cn)("space-y-2",r),...a})})});x.displayName="FormItem";let h=s.forwardRef((e,t)=>{let{className:r,required:s,...a}=e,{error:i,formItemId:c}=m();return(0,n.jsx)(o._,{ref:t,className:(0,l.cn)(i&&"text-destructive",s&&'after:ml-0.5 after:text-destructive after:content-["*"]',r),htmlFor:c,...a})});h.displayName="FormLabel";let p=s.forwardRef((e,t)=>{let{...r}=e,{error:s,formItemId:i,formDescriptionId:l,formMessageId:o}=m();return(0,n.jsx)(a.g7,{ref:t,id:i,"aria-describedby":s?"".concat(l," ").concat(o):"".concat(l),"aria-invalid":!!s,...r})});p.displayName="FormControl";let v=s.forwardRef((e,t)=>{let{className:r,...s}=e,{formDescriptionId:a}=m();return(0,n.jsx)("p",{ref:t,id:a,className:(0,l.cn)("text-sm text-muted-foreground",r),...s})});v.displayName="FormDescription";let g=s.forwardRef((e,t)=>{let{className:r,children:s,...a}=e,{error:i,formMessageId:o}=m(),c=i?String(null==i?void 0:i.message):s;return c?(0,n.jsx)("p",{ref:t,id:o,className:(0,l.cn)("text-sm font-medium text-destructive",r),...a,children:c}):null});g.displayName="FormMessage"},51908:function(e,t,r){"use strict";r.d(t,{I:function(){return i}});var n=r(57437),s=r(2265),a=r(39311);let i=s.forwardRef((e,t)=>{let{className:r,type:s,...i}=e;return(0,n.jsx)("input",{type:s,className:(0,a.cn)("flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",r),ref:t,...i})});i.displayName="Input"},66672:function(e,t,r){"use strict";r.d(t,{_:function(){return c}});var n=r(57437),s=r(2265),a=r(36743),i=r(7404),l=r(39311);let o=(0,i.j)("text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"),c=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)(a.f,{ref:t,className:(0,l.cn)(o(),r),...s})});c.displayName=a.f.displayName},61985:function(e,t,r){"use strict";r.d(t,{L:function(){return s},o:function(){return n}});let n="name@yourcompany.com",s=20},52485:function(e,t,r){"use strict";r.d(t,{Z:function(){return s}});var n=r(24033);function s(){let e=(0,n.usePathname)(),t=(0,n.useRouter)(),r=(0,n.useSearchParams)();return{pathname:e,router:t,searchParams:r,updateSearchParams:n=>{let{set:s,del:a,replace:i}=n,l=new URLSearchParams(r);s&&Object.entries(s).forEach(e=>{let[t,r]=e;return l.set(t,r)}),a&&(Array.isArray(a)?a.forEach(e=>l.delete(e)):l.delete(a));let o=l.toString(),c="".concat(e).concat(o.length>0?"?".concat(o):"");i?t.replace(c):t.push(c)},getQueryString:e=>{let t=new URLSearchParams(r);e&&Object.entries(e).forEach(e=>{let[r,n]=e;return t.set(r,n)});let n=t.toString();return n.length>0?"?".concat(n):""}}}},1592:function(e,t,r){"use strict";r.d(t,{Z:function(){return o}});var n=r(34084),s=r(53771),a=r(58001),i=r(7820),l=r(37004);async function o(e,t){var r;let n=null!==(r=null==t?void 0:t.customFetch)&&void 0!==r?r:window.fetch;if(function(e){var t;if(e.startsWith("/oauth/providers"))return!1;let r=null===(t=(0,l.bW)())||void 0===t?void 0:t.accessToken;if(!r)return!0;try{let{exp:e}=(0,s.o)(r);return!e||(0,l.pw)(e)}catch(e){return!0}}(e))return l.wG.refreshToken(c).then(r=>m(e,t));let a=await n(e,d(t));return 401===a.status?l.wG.refreshToken(c).then(r=>m(e,t)):f(a,t)}async function c(){var e,t;let r=null===(e=(0,l.bW)())||void 0===e?void 0:e.refreshToken;if(!r)return;let n=await u(r);return null==n?void 0:null===(t=n.data)||void 0===t?void 0:t.refreshToken}function d(e){var t;let r=new Headers(null==e?void 0:e.headers);return r.append("authorization","Bearer ".concat(null===(t=(0,l.bW)())||void 0===t?void 0:t.accessToken)),{...e||{},headers:r}}async function u(e){let t=i.L.createRequestOperation("mutation",(0,n.h)(a.Dp,{refreshToken:e}));return i.L.executeMutation(t)}function m(e,t){var r;let n=null!==(r=null==t?void 0:t.customFetch)&&void 0!==r?r:window.fetch;return n(e,d(t)).then(e=>f(e,t))}function f(e,t){return(null==e?void 0:e.ok)?(null==t?void 0:t.responseFormatter)?t.responseFormatter(e):(null==t?void 0:t.responseFormat)==="blob"?e.blob():e.json():(null==t?void 0:t.errorHandler)?t.errorHandler(e):void 0}},9381:function(e,t,r){"use strict";r.d(t,{WV:function(){return l},jH:function(){return o}});var n=r(13428),s=r(2265),a=r(54887),i=r(67256);let l=["a","button","div","form","h2","h3","img","input","label","li","nav","ol","p","span","svg","ul"].reduce((e,t)=>{let r=(0,s.forwardRef)((e,r)=>{let{asChild:a,...l}=e,o=a?i.g7:t;return(0,s.useEffect)(()=>{window[Symbol.for("radix-ui")]=!0},[]),(0,s.createElement)(o,(0,n.Z)({},l,{ref:r}))});return r.displayName=`Primitive.${t}`,{...e,[t]:r}},{});function o(e,t){e&&(0,a.flushSync)(()=>e.dispatchEvent(t))}},1589:function(e,t,r){"use strict";r.d(t,{Z:function(){return a}});var n=r(30713),s=r(44796);let a=(0,s.xD)(n.ZP,e=>(t,r,n)=>(n.revalidateOnFocus=!1,n.revalidateIfStale=!1,n.revalidateOnReconnect=!1,e(t,r,n)))}},function(e){e.O(0,[768,9109,584,993,5414,713,7753,4168,2445,2971,7864,1744],function(){return e(e.s=76846)}),_N_E=e.O()}]);