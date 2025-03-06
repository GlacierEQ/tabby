(self.webpackChunk_N_E=self.webpackChunk_N_E||[]).push([[3816],{24306:function(e,n,t){Promise.resolve().then(t.bind(t,49016))},49016:function(e,n,t){"use strict";t.r(n),t.d(n,{default:function(){return G}});var r=t(36164),s=t(98454),a=t(79972),i=t(6230),l=t(3546),o=t(99092),d=t.n(o),c=t(2578),u=t(40055),f=t(21808),m=t(43240),x=t(70526),p=t(11634),v=t(70410),h=t(31458),j=t(81565),g=t(49506),N=t(99047),b=t(48537),y=t(84381),w=t(5493),C=t(23782),R=t(98150),I=t(82394);let S=(0,m.BX)("\n  mutation CreateInvitation($email: String!) {\n    createInvitation(email: $email)\n  }\n"),A=C.Ry({email:C.Z_().email("Invalid email address")});function k(e){let{onCreated:n}=e,t=(0,w.cI)({resolver:(0,y.F)(A)}),{isSubmitting:s}=t.formState,a=(0,p.Db)(S,{onCompleted(){t.reset({email:""}),n()},form:t});return(0,r.jsx)(R.l0,{...t,children:(0,r.jsxs)("div",{className:"grid gap-2",children:[(0,r.jsxs)("form",{className:"flex w-full items-center gap-4",onSubmit:t.handleSubmit(a),children:[(0,r.jsx)(R.Wi,{control:t.control,name:"email",render:e=>{let{field:n}=e;return(0,r.jsx)(R.xJ,{children:(0,r.jsx)(R.NI,{children:(0,r.jsx)(I.I,{className:"w-60",placeholder:"e.g. ".concat(f.o0),type:"email",autoCapitalize:"none",autoComplete:"email",autoCorrect:"off",...n})})})}}),(0,r.jsx)(h.z,{type:"submit",disabled:s,children:"Invite"})]}),(0,r.jsx)(R.zG,{})]})})}let O=(0,m.BX)("\n  mutation DeleteInvitation($id: ID!) {\n    deleteInvitation(id: $id)\n  }\n"),P=f.L8;function U(){var e,n;let t=(0,u.m8)(),[{data:s,fetching:a}]=(0,u.aM)({query:v.lE,variables:{first:P}}),[o,f]=l.useState(!1),[m,y]=l.useState(1),w=null==s?void 0:null===(e=s.invitations)||void 0===e?void 0:e.edges,C=null==s?void 0:null===(n=s.invitations)||void 0===n?void 0:n.pageInfo,R=Math.ceil(((null==w?void 0:w.length)||0)/P),I=l.useMemo(()=>{var e;return null==w?void 0:null===(e=w.slice)||void 0===e?void 0:e.call(w,(m-1)*P,m*P)},[m,w]),S=(null==C?void 0:C.hasNextPage)||m<R,A=m>1,U=e=>t.query(v.lE,e).toPromise(),_=async e=>{var n,t,r,s,a;let i=await U({first:P,after:e}),l=(null==i?void 0:null===(r=i.data)||void 0===r?void 0:null===(t=r.invitations)||void 0===t?void 0:null===(n=t.edges)||void 0===n?void 0:n.length)||0,o=null==i?void 0:null===(a=i.data)||void 0===a?void 0:null===(s=a.invitations)||void 0===s?void 0:s.pageInfo;return(null==o?void 0:o.hasNextPage)&&(null==o?void 0:o.endCursor)&&(l=await _(o.endCursor)),l},D=async()=>{try{var e;f(!0);let n=_(null!==(e=null==C?void 0:C.endCursor)&&void 0!==e?e:void 0);return n}catch(e){return 0}finally{f(!1)}},z=(0,x.j)(),T=(0,p.Db)(O),F=async()=>{c.A.success("Invitation created"),D().then(e=>{y(Math.ceil((e||0)/P))})},E=e=>{T({id:e.id}).then(n=>{var t;if(null==n?void 0:n.error){c.A.error(n.error.message);return}(null==n?void 0:null===(t=n.data)||void 0===t?void 0:t.deleteInvitation)&&c.A.success("".concat(e.email," deleted"))})};return l.useEffect(()=>{R<m&&m>1&&y(R)},[R,m]),(0,r.jsxs)("div",{children:[(0,r.jsx)(k,{onCreated:F}),(0,r.jsx)("div",{className:"mt-4",children:(0,r.jsx)(i.Z,{loading:a,children:(0,r.jsxs)(N.iA,{className:"border-b",children:[!!(null==I?void 0:I.length)&&(0,r.jsx)(N.xD,{children:(0,r.jsxs)(N.SC,{children:[(0,r.jsx)(N.ss,{className:"w-[25%]",children:"Invitee"}),(0,r.jsx)(N.ss,{className:"w-[45%]",children:"Created"}),(0,r.jsx)(N.ss,{})]})}),(0,r.jsx)(N.RM,{children:null==I?void 0:I.map(e=>{let n="".concat(z,"/auth/signup?invitationCode=").concat(e.node.code);return(0,r.jsxs)(N.SC,{children:[(0,r.jsx)(N.pj,{children:e.node.email}),(0,r.jsx)(N.pj,{children:d().utc(e.node.createdAt).fromNow()}),(0,r.jsx)(N.pj,{className:"flex justify-end",children:(0,r.jsxs)("div",{className:"flex gap-1",children:[(0,r.jsx)(b.q,{value:n}),(0,r.jsx)(h.z,{size:"icon",variant:"hover-destructive",onClick:()=>E(e.node),children:(0,r.jsx)(j.IconTrash,{})})]})})]},e.node.id)})})]})})}),(S||A)&&(0,r.jsx)(g.tl,{className:"my-4",children:(0,r.jsxs)(g.ng,{children:[(0,r.jsx)(g.nt,{children:(0,r.jsx)(g.dN,{disabled:!A,onClick:()=>{!(m<=1)&&(o||a||y(e=>e-1))}})}),(0,r.jsx)(g.nt,{children:(0,r.jsx)(g.$0,{disabled:!S,onClick:()=>{S&&(o||a||U({first:P,after:null==C?void 0:C.endCursor}).then(e=>{var n,t,r;(null==e?void 0:null===(r=e.data)||void 0===r?void 0:null===(t=r.invitations)||void 0===t?void 0:null===(n=t.edges)||void 0===n?void 0:n.length)&&y(e=>e+1)}))}})})]})})]})}var _=t(28312),D=t(57288),z=t(73460),T=t(63795),F=t(62202),E=t(29),$=t(75561),M=t(18500),Y=t(94770);let L=(0,$.B)("\n  mutation updateUserRole($id: ID!, $isAdmin: Boolean!) {\n    updateUserRole(id: $id, isAdmin: $isAdmin)\n  }\n"),Z=e=>{let{user:n,onSuccess:t,open:s,onOpenChange:a,isPromote:i}=e,[o,d]=l.useState(!1),u=(0,p.Db)(L),f=async e=>{if(e.preventDefault(),!(null==n?void 0:n.id)){c.A.error("Oops! Something went wrong. Please try again.");return}return d(!0),u({id:n.id,isAdmin:!!i}).then(e=>{var n,r,s;(null==e?void 0:null===(n=e.data)||void 0===n?void 0:n.updateUserRole)?null==t||t():(null==e?void 0:e.error)&&c.A.error(null!==(s=null===(r=e.error)||void 0===r?void 0:r.message)&&void 0!==s?s:"update failed")}).finally(()=>{d(!1)})},m=(0,r.jsx)("span",{className:"font-bold",children:null==n?void 0:n.email}),x=i?(0,r.jsxs)(r.Fragment,{children:["Are you sure you want to grant admin privileges to ",m]}):(0,r.jsxs)(r.Fragment,{children:["Are you sure you want to downgrade ",m," to a regular member?"]});return(0,r.jsx)(z.aR,{open:s,onOpenChange:a,children:(0,r.jsxs)(z._T,{children:[(0,r.jsxs)(z.fY,{className:"gap-3",children:[(0,r.jsx)(z.f$,{children:i?"Upgrade to admin":"Downgrade to member"}),(0,r.jsx)(z.yT,{children:x})]}),(0,r.jsxs)(z.xo,{children:[(0,r.jsx)(z.le,{children:"Cancel"}),(0,r.jsx)(Y.M,{licenses:[M.oj.Team,M.oj.Enterprise],children:e=>{let{hasValidLicense:n}=e;return(0,r.jsxs)(z.OL,{className:(0,h.d)(),onClick:f,disabled:!n||o,children:[o&&(0,r.jsx)(j.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"}),"Confirm"]})}})]})]})})},B=(0,m.BX)("\n  mutation UpdateUserActive($id: ID!, $active: Boolean!) {\n    updateUserActive(id: $id, active: $active)\n  }\n"),V=(0,m.BX)("\n  mutation generateResetPasswordUrl($userId: ID!) {\n    generateResetPasswordUrl(userId: $userId)\n  }\n"),X=f.L8;function q(){var e;let[{data:n}]=(0,s.P)(),[t,a]=l.useState({first:X}),[{data:o,error:f,fetching:m},x]=(0,u.aM)({query:v.TH,variables:t}),[h,j]=l.useState(),[b,y]=l.useState(),[w,C]=l.useState(!1),[R,I]=l.useState(!1);l.useEffect(()=>{var e;let n=null==o?void 0:o.users;(null==n?void 0:null===(e=n.edges)||void 0===e?void 0:e.length)&&j(n)},[o]),l.useEffect(()=>{(null==f?void 0:f.message)&&c.A.error(f.message)},[f]);let S=(0,p.Db)(B),A=(e,n)=>{S({id:e.id,active:n}).then(e=>{var t,r;if((null==e?void 0:e.error)||!(null==e?void 0:null===(t=e.data)||void 0===t?void 0:t.updateUserActive)){c.A.error((null==e?void 0:null===(r=e.error)||void 0===r?void 0:r.message)||"".concat(n?"activate":"deactivate"," failed"));return}x()})},k=e=>{y(e),C(!0),I(!e.isAdmin)},O=null==h?void 0:h.pageInfo,P=e=>e.isOwner?(0,r.jsx)(T.C,{children:"OWNER"}):e.isAdmin?(0,r.jsx)(T.C,{children:"ADMIN"}):(0,r.jsx)(T.C,{variant:"secondary",children:"MEMBER"});return(0,r.jsxs)(r.Fragment,{children:[(0,r.jsx)(i.Z,{loading:m,children:!!(null==h?void 0:null===(e=h.edges)||void 0===e?void 0:e.length)&&(0,r.jsxs)(r.Fragment,{children:[(0,r.jsxs)(N.iA,{className:"border-b",children:[(0,r.jsx)(N.xD,{children:(0,r.jsxs)(N.SC,{children:[(0,r.jsx)(N.ss,{className:"w-[20%]",children:"Name"}),(0,r.jsx)(N.ss,{className:"w-[25%]",children:"Email"}),(0,r.jsx)(N.ss,{className:"w-[15%]",children:"Joined"}),(0,r.jsx)(N.ss,{className:"w-[20%] text-center",children:"Status"}),(0,r.jsx)(N.ss,{className:"w-[20%] text-center",children:"Level"}),(0,r.jsx)(N.ss,{className:"w-[100px]"})]})}),(0,r.jsx)(N.RM,{children:h.edges.map(e=>{var t;let s=!e.node.isOwner&&(null==n?void 0:null===(t=n.me)||void 0===t?void 0:t.isAdmin)&&e.node.id!==n.me.id;return(0,r.jsxs)(N.SC,{children:[(0,r.jsx)(N.pj,{children:e.node.name}),(0,r.jsx)(N.pj,{children:e.node.email}),(0,r.jsx)(N.pj,{children:d().utc(e.node.createdAt).fromNow()}),(0,r.jsx)(N.pj,{className:"text-center",children:e.node.active?(0,r.jsx)(T.C,{variant:"successful",children:"Active"}):(0,r.jsx)(T.C,{variant:"secondary",children:"Inactive"})}),(0,r.jsx)(N.pj,{className:"text-center",children:P(e.node)}),(0,r.jsx)(N.pj,{className:"text-end",children:s&&(0,r.jsx)(W,{user:e,onUpdateUserActive:A,onUpdateUserRole:k})})]},e.node.id)})})]}),((null==O?void 0:O.hasNextPage)||(null==O?void 0:O.hasPreviousPage))&&(0,r.jsx)(g.tl,{className:"my-4",children:(0,r.jsxs)(g.ng,{children:[(0,r.jsx)(g.nt,{children:(0,r.jsx)(g.dN,{disabled:!(null==O?void 0:O.hasPreviousPage),onClick:e=>a({last:X,before:null==O?void 0:O.startCursor})})}),(0,r.jsx)(g.nt,{children:(0,r.jsx)(g.$0,{disabled:!(null==O?void 0:O.hasNextPage),onClick:e=>a({first:X,after:null==O?void 0:O.endCursor})})})]})})]})}),(0,r.jsx)(Z,{onSuccess:()=>{x(),C(!1)},user:b,isPromote:R,open:w,onOpenChange:C})]})}function W(e){let{user:n,onUpdateUserActive:t,onUpdateUserRole:s}=e,[a,i]=(0,l.useState)(!1),[o,d]=(0,l.useState)(!1),{copyToClipboard:u,isCopied:f}=(0,_.m)({timeout:1e3}),m=(0,p.Db)(V);return(0,l.useEffect)(()=>{f&&c.A.success("Password reset link copied to clipboard")},[f]),(0,r.jsxs)(r.Fragment,{children:[(0,r.jsxs)(F.h_,{modal:!1,children:[(0,r.jsx)(F.$F,{asChild:!0,children:(0,r.jsx)(h.z,{size:"icon",variant:"ghost",children:(0,r.jsx)(j.IconMore,{})})}),(0,r.jsxs)(F.AW,{collisionPadding:{right:16},children:[!!n.node.active&&(0,r.jsx)(F.Xi,{onSelect:()=>s(n.node),className:"cursor-pointer",children:(0,r.jsx)("span",{className:"ml-2",children:n.node.isAdmin?"Downgrade to member":"Upgrade to admin"})}),!!n.node.active&&(0,r.jsx)(F.Xi,{onSelect:()=>t(n.node,!1),className:"cursor-pointer",children:(0,r.jsx)("span",{className:"ml-2",children:"Deactivate"})}),!n.node.active&&(0,r.jsx)(F.Xi,{onSelect:()=>t(n.node,!0),className:"cursor-pointer",children:(0,r.jsx)("span",{className:"ml-2",children:"Activate"})}),(0,r.jsxs)(E.u,{children:[(0,r.jsx)(E.aJ,{asChild:!0,children:(0,r.jsx)("span",{children:(0,r.jsx)(F.Xi,{disabled:n.node.isSsoUser,onSelect:()=>i(!0),className:"cursor-pointer gap-1",children:(0,r.jsxs)("span",{className:"flex items-center gap-1",children:[(0,r.jsx)("span",{className:"ml-2",children:"Reset password"}),n.node.isSsoUser&&(0,r.jsx)(j.IconInfoCircled,{})]})})})}),(0,r.jsx)(E._v,{side:"left",sideOffset:8,align:"start",hidden:!n.node.isSsoUser,className:"max-w-xs",children:(0,r.jsx)("p",{children:"The password reset feature cannot be used for users created through SSO"})})]})]})]}),(0,r.jsx)(z.aR,{open:a,onOpenChange:e=>{o||i(e)},children:(0,r.jsxs)(z._T,{children:[(0,r.jsxs)(z.fY,{children:[(0,r.jsx)(z.f$,{children:"Reset password"}),(0,r.jsxs)(z.yT,{children:["By clicking ",'"',"Yes",'"',", a password reset link will be generated for"," ",(0,r.jsx)("span",{className:"font-bold",children:n.node.name||n.node.email}),". The password won't be modified until the user follows the instructions in the link to make the change."]})]}),(0,r.jsxs)(z.xo,{children:[(0,r.jsx)(z.le,{disabled:o,children:"Cancel"}),(0,r.jsxs)(z.OL,{className:(0,D.cn)((0,h.d)(),"gap-1"),disabled:o,onClick:e=>{e.preventDefault(),o||(d(!0),m({userId:n.node.id}).then(e=>{var n,t;let r=null==e?void 0:null===(n=e.data)||void 0===n?void 0:n.generateResetPasswordUrl;r?(u(r),i(!1)):c.A.error((null==e?void 0:null===(t=e.error)||void 0===t?void 0:t.message)||"Failed to generate password reset link")}).catch(e=>{c.A.error((null==e?void 0:e.message)||"Failed to generate password reset link")}).finally(()=>{d(!1)}))},children:[o&&(0,r.jsx)(j.IconSpinner,{}),"Yes"]})]})]})})]})}function G(){let[{data:e,fetching:n}]=(0,s.P)();return(0,r.jsxs)(i.Z,{loading:n,children:[(null==e?void 0:e.me.isAdmin)&&(0,r.jsxs)(r.Fragment,{children:[(0,r.jsxs)("div",{children:[(0,r.jsx)(a.Ol,{className:"pl-0 pt-0",children:(0,r.jsx)(a.ll,{children:"Pending Invites"})}),(0,r.jsx)(a.aY,{className:"pl-0",children:(0,r.jsx)(U,{})})]}),(0,r.jsx)("div",{className:"h-16"})]}),(0,r.jsxs)("div",{children:[(0,r.jsx)(a.Ol,{className:"pl-0 pt-0",children:(0,r.jsx)(a.ll,{children:"Users"})}),(0,r.jsx)(a.aY,{className:"pl-0",children:(0,r.jsx)(q,{})})]})]})}},48537:function(e,n,t){"use strict";t.d(n,{q:function(){return l}});var r=t(36164);t(3546);var s=t(28312),a=t(31458),i=t(81565);function l(e){let{className:n,value:t,onCopyContent:l,text:o,...d}=e,{isCopied:c,copyToClipboard:u}=(0,s.m)({timeout:2e3,onCopyContent:l});return t?(0,r.jsxs)(a.z,{variant:"ghost",size:o?"default":"icon",className:n,onClick:()=>{c||u(t)},...d,children:[c?(0,r.jsx)(i.IconCheck,{className:"text-green-600"}):(0,r.jsx)(i.IconCopy,{}),o&&(0,r.jsx)("span",{children:o}),!o&&(0,r.jsx)("span",{className:"sr-only",children:"Copy"})]}):null}},94770:function(e,n,t){"use strict";t.d(n,{M:function(){return f}});var r=t(36164),s=t(3546),a=t(70652),i=t.n(a),l=t(88542),o=t(29917),d=t(57288),c=t(31458),u=t(90615);let f=e=>{let{licenses:n,children:t}=e,[a,i]=s.useState(!1),l=(0,o.Gm)(),c=(0,o.Cz)({licenses:n}),{isLicenseOK:f,hasSufficientLicense:x}=c,p=x&&f,v=e=>{p||i(e)};return(0,r.jsxs)(u.zs,{open:a,onOpenChange:v,openDelay:100,children:[(0,r.jsx)(u.bZ,{side:"top",collisionPadding:16,className:"w-[400px]",children:(0,r.jsx)(m,{licenses:n,...c})}),(0,r.jsx)(u.Yi,{asChild:!0,onClick:e=>{p||(e.preventDefault(),v(!0))},children:(0,r.jsx)("div",{className:(0,d.cn)(p?"":"cursor-not-allowed"),children:t({hasValidLicense:p,license:l})})})]})};function m(e){let{hasSufficientLicense:n,isExpired:t,isSeatsExceeded:s,licenses:a}=e,o=(0,l.Z)(a[0]),d=o;return(2==a.length&&(d="".concat((0,l.Z)(a[0])," or ").concat((0,l.Z)(a[1]))),n&&t)?(0,r.jsxs)(r.Fragment,{children:[(0,r.jsx)("div",{children:"Your license has expired. Please update your license to use this feature."}),(0,r.jsx)("div",{className:"mt-4 text-center",children:(0,r.jsx)(i(),{className:(0,c.d)(),href:"/settings/subscription",children:"Update license"})})]}):n&&s?(0,r.jsxs)(r.Fragment,{children:[(0,r.jsx)("div",{children:"Your seat count has exceeded the limit. Please upgrade your license to continue using this feature."}),(0,r.jsx)("div",{className:"mt-4 text-center",children:(0,r.jsx)(i(),{className:(0,c.d)(),href:"/settings/subscription",children:"Upgrade license"})})]}):(0,r.jsxs)(r.Fragment,{children:[(0,r.jsxs)("div",{children:["This feature is only available on Tabby's"," ",(0,r.jsx)("span",{className:"font-semibold",children:d})," plan. Upgrade to use this feature."]}),(0,r.jsx)("div",{className:"mt-4 text-center",children:(0,r.jsxs)(i(),{className:(0,c.d)(),href:"/settings/subscription",children:["Upgrade to ",o]})})]})}f.displayName="LicenseGuard"},6230:function(e,n,t){"use strict";var r=t(36164),s=t(3546),a=t(24449),i=t(90379);n.Z=e=>{let{triggerOnce:n=!0,loading:t,fallback:l,delay:o,children:d}=e,[c,u]=s.useState(!t),[f]=(0,a.n)(c,null!=o?o:200);return(s.useEffect(()=>{n?t||c||u(!0):u(!t)},[t]),f)?d:l||(0,r.jsx)(i.cg,{})}},90379:function(e,n,t){"use strict";t.d(n,{PF:function(){return o},cg:function(){return i},tB:function(){return l}});var r=t(36164),s=t(57288),a=t(3448);let i=e=>{let{className:n,...t}=e;return(0,r.jsxs)("div",{className:(0,s.cn)("space-y-3",n),...t,children:[(0,r.jsx)(a.O,{className:"h-4 w-full"}),(0,r.jsx)(a.O,{className:"h-4 w-full"}),(0,r.jsx)(a.O,{className:"h-4 w-full"}),(0,r.jsx)(a.O,{className:"h-4 w-full"})]})},l=e=>{let{className:n,...t}=e;return(0,r.jsx)(a.O,{className:(0,s.cn)("h-4 w-full",n),...t})},o=e=>{let{className:n,...t}=e;return(0,r.jsxs)("div",{className:(0,s.cn)("flex flex-col gap-3",n),...t,children:[(0,r.jsx)(a.O,{className:"h-4 w-[20%]"}),(0,r.jsx)(a.O,{className:"h-4 w-full"}),(0,r.jsx)(a.O,{className:"h-4 w-[20%]"}),(0,r.jsx)(a.O,{className:"h-4 w-full"})]})}},73460:function(e,n,t){"use strict";t.d(n,{OL:function(){return h},_T:function(){return f},aR:function(){return o},f$:function(){return p},fY:function(){return m},le:function(){return j},vW:function(){return d},xo:function(){return x},yT:function(){return v}});var r=t(36164),s=t(3546),a=t(28961),i=t(57288),l=t(31458);let o=a.fC,d=a.xz,c=e=>{let{className:n,children:t,...s}=e;return(0,r.jsx)(a.h_,{className:(0,i.cn)(n),...s,children:(0,r.jsx)("div",{className:"fixed inset-0 z-50 flex items-end justify-center sm:items-center",children:t})})};c.displayName=a.h_.displayName;let u=s.forwardRef((e,n)=>{let{className:t,children:s,...l}=e;return(0,r.jsx)(a.aV,{className:(0,i.cn)("fixed inset-0 z-50 bg-background/80 backdrop-blur-sm transition-opacity animate-in fade-in",t),...l,ref:n})});u.displayName=a.aV.displayName;let f=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsxs)(c,{children:[(0,r.jsx)(u,{}),(0,r.jsx)(a.VY,{ref:n,className:(0,i.cn)("fixed z-50 grid w-full max-w-lg scale-100 gap-4 border bg-background p-6 opacity-100 shadow-lg animate-in fade-in-90 slide-in-from-bottom-10 sm:rounded-lg sm:zoom-in-90 sm:slide-in-from-bottom-0 md:w-full",t),...s})]})});f.displayName=a.VY.displayName;let m=e=>{let{className:n,...t}=e;return(0,r.jsx)("div",{className:(0,i.cn)("flex flex-col space-y-2 text-center sm:text-left",n),...t})};m.displayName="AlertDialogHeader";let x=e=>{let{className:n,...t}=e;return(0,r.jsx)("div",{className:(0,i.cn)("flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",n),...t})};x.displayName="AlertDialogFooter";let p=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)(a.Dx,{ref:n,className:(0,i.cn)("text-lg font-semibold",t),...s})});p.displayName=a.Dx.displayName;let v=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)(a.dk,{ref:n,className:(0,i.cn)("text-sm text-muted-foreground",t),...s})});v.displayName=a.dk.displayName;let h=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)(a.aU,{ref:n,className:(0,i.cn)((0,l.d)(),t),...s})});h.displayName=a.aU.displayName;let j=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)(a.$j,{ref:n,className:(0,i.cn)((0,l.d)({variant:"outline"}),"mt-2 sm:mt-0",t),...s})});j.displayName=a.$j.displayName},63795:function(e,n,t){"use strict";t.d(n,{C:function(){return l}});var r=t(36164);t(3546);var s=t(14375),a=t(57288);let i=(0,s.j)("inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",{variants:{variant:{default:"border-transparent bg-primary text-primary-foreground hover:bg-primary/80",secondary:"border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",destructive:"border-transparent bg-destructive text-destructive-foreground hover:bg-destructive/80",successful:"border-transparent bg-successful text-successful-foreground hover:bg-successful/80",outline:"text-foreground"}},defaultVariants:{variant:"default"}});function l(e){let{className:n,variant:t,...s}=e;return(0,r.jsx)("div",{className:(0,a.cn)(i({variant:t}),n),...s})}},79972:function(e,n,t){"use strict";t.d(n,{Ol:function(){return l},Zb:function(){return i},aY:function(){return c},eW:function(){return u},ll:function(){return o}});var r=t(36164),s=t(3546),a=t(57288);let i=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("div",{ref:n,className:(0,a.cn)("rounded-lg border bg-card text-card-foreground shadow-sm",t),...s})});i.displayName="Card";let l=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("div",{ref:n,className:(0,a.cn)("flex flex-col space-y-1.5 p-6",t),...s})});l.displayName="CardHeader";let o=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("h3",{ref:n,className:(0,a.cn)("text-2xl font-semibold leading-none tracking-tight",t),...s})});o.displayName="CardTitle";let d=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("p",{ref:n,className:(0,a.cn)("text-sm text-muted-foreground",t),...s})});d.displayName="CardDescription";let c=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("div",{ref:n,className:(0,a.cn)("p-6 pt-0",t),...s})});c.displayName="CardContent";let u=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("div",{ref:n,className:(0,a.cn)("flex items-center p-6 pt-0",t),...s})});u.displayName="CardFooter"},62202:function(e,n,t){"use strict";t.d(n,{$F:function(){return o},AW:function(){return u},Ju:function(){return x},VD:function(){return p},Xi:function(){return f},_x:function(){return d},h_:function(){return l},qB:function(){return m}});var r=t(36164),s=t(3546),a=t(19148),i=t(57288);let l=a.fC,o=a.xz;a.ZA,a.Uv,a.Tr;let d=a.Ee;a.wU;let c=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)(a.tu,{ref:n,className:(0,i.cn)("z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md animate-in data-[side=bottom]:slide-in-from-top-1 data-[side=left]:slide-in-from-right-1 data-[side=right]:slide-in-from-left-1 data-[side=top]:slide-in-from-bottom-1",t),...s})});c.displayName=a.tu.displayName;let u=s.forwardRef((e,n)=>{let{className:t,sideOffset:s=4,...l}=e;return(0,r.jsx)(a.Uv,{children:(0,r.jsx)(a.VY,{ref:n,sideOffset:s,className:(0,i.cn)("z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow animate-in data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",t),...l})})});u.displayName=a.VY.displayName;let f=s.forwardRef((e,n)=>{let{className:t,inset:s,...l}=e;return(0,r.jsx)(a.ck,{ref:n,className:(0,i.cn)("relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",s&&"pl-8",t),...l})});f.displayName=a.ck.displayName;let m=s.forwardRef((e,n)=>{let{className:t,inset:s,...l}=e;return(0,r.jsx)(a.Rk,{ref:n,className:(0,i.cn)("relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",s&&"pl-8",t),...l})});m.displayName=a.Rk.displayName;let x=s.forwardRef((e,n)=>{let{className:t,inset:s,...l}=e;return(0,r.jsx)(a.__,{ref:n,className:(0,i.cn)("px-2 py-1.5 text-sm font-semibold",s&&"pl-8",t),...l})});x.displayName=a.__.displayName;let p=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)(a.Z0,{ref:n,className:(0,i.cn)("-mx-1 my-1 h-px bg-muted",t),...s})});p.displayName=a.Z0.displayName},98150:function(e,n,t){"use strict";t.d(n,{NI:function(){return v},Wi:function(){return u},l0:function(){return d},lX:function(){return p},pf:function(){return h},xJ:function(){return x},zG:function(){return j}});var r=t(36164),s=t(3546),a=t(74047),i=t(5493),l=t(57288),o=t(5266);let d=i.RV,c=s.createContext({}),u=e=>{let{...n}=e;return(0,r.jsx)(c.Provider,{value:{name:n.name},children:(0,r.jsx)(i.Qr,{...n})})},f=()=>{let e=s.useContext(c),n=s.useContext(m),{getFieldState:t,formState:r}=(0,i.Gc)(),a=e.name||"root",l=t(a,r);if(!r)throw Error("useFormField should be used within <Form>");let{id:o}=n;return{id:o,name:a,formItemId:"".concat(o,"-form-item"),formDescriptionId:"".concat(o,"-form-item-description"),formMessageId:"".concat(o,"-form-item-message"),...l}},m=s.createContext({}),x=s.forwardRef((e,n)=>{let{className:t,...a}=e,i=s.useId();return(0,r.jsx)(m.Provider,{value:{id:i},children:(0,r.jsx)("div",{ref:n,className:(0,l.cn)("space-y-2",t),...a})})});x.displayName="FormItem";let p=s.forwardRef((e,n)=>{let{className:t,required:s,...a}=e,{error:i,formItemId:d}=f();return(0,r.jsx)(o._,{ref:n,className:(0,l.cn)(i&&"text-destructive",s&&'after:ml-0.5 after:text-destructive after:content-["*"]',t),htmlFor:d,...a})});p.displayName="FormLabel";let v=s.forwardRef((e,n)=>{let{...t}=e,{error:s,formItemId:i,formDescriptionId:l,formMessageId:o}=f();return(0,r.jsx)(a.g7,{ref:n,id:i,"aria-describedby":s?"".concat(l," ").concat(o):"".concat(l),"aria-invalid":!!s,...t})});v.displayName="FormControl";let h=s.forwardRef((e,n)=>{let{className:t,...s}=e,{formDescriptionId:a}=f();return(0,r.jsx)("div",{ref:n,id:a,className:(0,l.cn)("text-sm text-muted-foreground",t),...s})});h.displayName="FormDescription";let j=s.forwardRef((e,n)=>{let{className:t,children:s,...a}=e,{error:i,formMessageId:o}=f(),d=i?String(null==i?void 0:i.message):s;return d?(0,r.jsx)("p",{ref:n,id:o,className:(0,l.cn)("text-sm font-medium text-destructive",t),...a,children:d}):null});j.displayName="FormMessage"},90615:function(e,n,t){"use strict";t.d(n,{Yi:function(){return o},bZ:function(){return d},zs:function(){return l}});var r=t(36164),s=t(3546),a=t(38421),i=t(57288);let l=a.fC,o=a.xz;a.h_;let d=s.forwardRef((e,n)=>{let{className:t,align:s="center",sideOffset:l=4,...o}=e;return(0,r.jsx)(a.VY,{ref:n,align:s,sideOffset:l,className:(0,i.cn)("z-50 w-64 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",t),...o})});d.displayName=a.VY.displayName},82394:function(e,n,t){"use strict";t.d(n,{I:function(){return i}});var r=t(36164),s=t(3546),a=t(57288);let i=s.forwardRef((e,n)=>{let{className:t,type:s,...i}=e;return(0,r.jsx)("input",{type:s,className:(0,a.cn)("flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",t),ref:n,...i})});i.displayName="Input"},5266:function(e,n,t){"use strict";t.d(n,{_:function(){return d}});var r=t(36164),s=t(3546),a=t(90893),i=t(14375),l=t(57288);let o=(0,i.j)("text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"),d=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)(a.f,{ref:n,className:(0,l.cn)(o(),t),...s})});d.displayName=a.f.displayName},49506:function(e,n,t){"use strict";t.d(n,{$0:function(){return m},Dj:function(){return x},dN:function(){return f},kN:function(){return u},ng:function(){return d},nt:function(){return c},tl:function(){return o}});var r=t(36164),s=t(3546),a=t(57288),i=t(31458),l=t(81565);let o=e=>{let{className:n,...t}=e;return(0,r.jsx)("nav",{role:"navigation","aria-label":"pagination",className:(0,a.cn)("mx-auto flex w-full justify-center",n),...t})};o.displayName="Pagination";let d=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("ul",{ref:n,className:(0,a.cn)("flex flex-row items-center gap-1",t),...s})});d.displayName="PaginationContent";let c=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("li",{ref:n,className:(0,a.cn)("",t),...s})});c.displayName="PaginationItem";let u=e=>{let{className:n,isActive:t,size:s="icon",...l}=e;return(0,r.jsx)("a",{"aria-current":t?"page":void 0,className:(0,a.cn)("select-none",(0,i.d)({variant:t?"outline":"ghost",size:s}),n),...l})};u.displayName="PaginationLink";let f=e=>{let{className:n,disabled:t,...s}=e;return(0,r.jsxs)(u,{"aria-label":"Go to previous page",size:"default",className:(0,a.cn)("cursor-pointer select-none gap-1 pl-2.5",t&&"cursor-not-allowed text-muted-foreground",n),...s,children:[(0,r.jsx)(l.IconChevronLeft,{className:"h-4 w-4"}),(0,r.jsx)("span",{children:"Previous"})]})};f.displayName="PaginationPrevious";let m=e=>{let{className:n,disabled:t,...s}=e;return(0,r.jsxs)(u,{"aria-label":"Go to next page",size:"default",className:(0,a.cn)("cursor-pointer select-none gap-1 pr-2.5",t&&"cursor-not-allowed text-muted-foreground",n),...s,children:[(0,r.jsx)("span",{children:"Next"}),(0,r.jsx)(l.IconChevronRight,{className:"h-4 w-4"})]})};m.displayName="PaginationNext";let x=e=>{let{className:n,...t}=e;return(0,r.jsxs)("span",{"aria-hidden":!0,className:(0,a.cn)("flex h-9 w-9 items-center justify-center",n),...t,children:[(0,r.jsx)(l.IconMore,{className:"h-4 w-4"}),(0,r.jsx)("span",{className:"sr-only",children:"More pages"})]})};x.displayName="PaginationEllipsis"},3448:function(e,n,t){"use strict";t.d(n,{O:function(){return a}});var r=t(36164),s=t(57288);function a(e){let{className:n,...t}=e;return(0,r.jsx)("div",{className:(0,s.cn)("h-4 animate-pulse rounded-md bg-border",n),...t})}},99047:function(e,n,t){"use strict";t.d(n,{RM:function(){return o},SC:function(){return c},iA:function(){return i},pj:function(){return f},ss:function(){return u},xD:function(){return l}});var r=t(36164),s=t(3546),a=t(57288);let i=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("table",{ref:n,className:(0,a.cn)("w-full caption-bottom text-sm",t),...s})});i.displayName="Table";let l=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("thead",{ref:n,className:(0,a.cn)("[&_tr]:border-b",t),...s})});l.displayName="TableHeader";let o=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("tbody",{ref:n,className:(0,a.cn)("[&_tr:last-child]:border-0",t),...s})});o.displayName="TableBody";let d=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("tfoot",{ref:n,className:(0,a.cn)("border-t bg-muted/50 font-medium [&>tr]:last:border-b-0",t),...s})});d.displayName="TableFooter";let c=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("tr",{ref:n,className:(0,a.cn)("border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted",t),...s})});c.displayName="TableRow";let u=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("th",{ref:n,className:(0,a.cn)("h-12 px-2 text-left align-middle font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0",t),...s})});u.displayName="TableHead";let f=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("td",{ref:n,className:(0,a.cn)("p-2 align-middle [&:has([role=checkbox])]:pr-0",t),...s})});f.displayName="TableCell";let m=s.forwardRef((e,n)=>{let{className:t,...s}=e;return(0,r.jsx)("caption",{ref:n,className:(0,a.cn)("mt-4 text-sm text-muted-foreground",t),...s})});m.displayName="TableCaption"},29:function(e,n,t){"use strict";t.d(n,{_v:function(){return c},aJ:function(){return d},pn:function(){return l},u:function(){return o}});var r=t(36164),s=t(3546),a=t(44421),i=t(57288);let l=a.zt,o=a.fC,d=a.xz;a.h_;let c=s.forwardRef((e,n)=>{let{className:t,sideOffset:s=4,...l}=e;return(0,r.jsx)(a.VY,{ref:n,sideOffset:s,className:(0,i.cn)("z-50 overflow-hidden rounded-md border bg-popover px-3 py-1.5 text-xs font-medium text-popover-foreground shadow-md animate-in fade-in-50 data-[side=bottom]:slide-in-from-top-1 data-[side=left]:slide-in-from-right-1 data-[side=right]:slide-in-from-left-1 data-[side=top]:slide-in-from-bottom-1",t),...l})});c.displayName=a.VY.displayName},21808:function(e,n,t){"use strict";t.d(n,{$6:function(){return a},$I:function(){return i},L8:function(){return s},ir:function(){return l},o0:function(){return r},rZ:function(){return o}});let r="name@yourcompany.com",s=20,a={DEMO_AUTO_LOGIN:"_tabby_demo_autologin"},i=48,l="NOT_FOUND",o="\n"},28312:function(e,n,t){"use strict";t.d(n,{m:function(){return l}});var r=t(3546),s=t(61200),a=t.n(s),i=t(2578);function l(e){let{timeout:n=2e3,onError:t,onCopyContent:s}=e,[l,o]=r.useState(!1),d=()=>{o(!0),setTimeout(()=>{o(!1)},n)},c=e=>{if("function"==typeof t){null==t||t(e);return}i.A.error("Failed to copy.")};return{isCopied:l,copyToClipboard:e=>{var n;if(e){if(s){s(e),d();return}if(null===(n=navigator.clipboard)||void 0===n?void 0:n.writeText)navigator.clipboard.writeText(e).then(d).catch(c);else{let n=a()(e);n?d():c()}}}}}},24449:function(e,n,t){"use strict";t.d(n,{S:function(){return l},n:function(){return o}});var r=t(3546),s=t(45391),a=t(16784);let i=e=>{let n=(0,a.d)(e);r.useEffect(()=>()=>{n.current()},[])};function l(e,n,t){let l=(0,a.d)(e),o=r.useMemo(()=>(0,s.Z)(function(){for(var e=arguments.length,n=Array(e),t=0;t<e;t++)n[t]=arguments[t];return l.current(...n)},n,t),[]);return i(()=>{var e;null==t||null===(e=t.onUnmount)||void 0===e||e.call(t,o),o.cancel()}),{run:o,cancel:o.cancel,flush:o.flush}}function o(e,n,t){let[s,a]=r.useState(e),{run:i}=l(()=>{a(e)},n,t);return r.useEffect(()=>{i()},[e]),[s,a]}},16784:function(e,n,t){"use strict";t.d(n,{d:function(){return s}});var r=t(3546);function s(e){let n=r.useRef(e);return n.current=e,n}},29917:function(e,n,t){"use strict";t.d(n,{Cz:function(){return c},Gm:function(){return d},jp:function(){return o}});var r=t(11978),s=t(40055),a=t(43240),i=t(18500);let l=(0,a.BX)("\n  query GetLicenseInfo {\n    license {\n      type\n      status\n      seats\n      seatsUsed\n      issuedAt\n      expiresAt\n    }\n  }\n"),o=()=>(0,s.aM)({query:l}),d=()=>{let[{data:e}]=o();return null==e?void 0:e.license},c=e=>{var n;let[{data:t}]=o(),s=null==t?void 0:t.license,a=(0,r.useSearchParams)(),l=!!s&&(!(null==e?void 0:null===(n=e.licenses)||void 0===n?void 0:n.length)||e.licenses.includes(s.type)),d=(null==s?void 0:s.status)===i.rW.Ok,c=(null==s?void 0:s.status)===i.rW.Expired,u=(null==s?void 0:s.status)===(null===i.rW||void 0===i.rW?void 0:i.rW.SeatsExceeded),f="expired"===a.get("licenseError"),m="seatsExceed"===a.get("licenseError");return{hasLicense:!!s,isLicenseOK:d&&!(f||m),isExpired:c||f,isSeatsExceeded:u||m,hasSufficientLicense:l}}},98454:function(e,n,t){"use strict";t.d(n,{P:function(){return i}});var r=t(40055),s=t(43240);let a=(0,s.BX)("\n  query MeQuery {\n    me {\n      id\n      email\n      name\n      isAdmin\n      isOwner\n      authToken\n      isPasswordSet\n      isSsoUser\n    }\n  }\n"),i=()=>(0,r.aM)({query:a})},70526:function(e,n,t){"use strict";t.d(n,{e:function(){return o},j:function(){return d}});var r=t(3546),s=t(40055),a=t(43240),i=t(57288);let l=(0,a.BX)("\n  query NetworkSetting {\n    networkSetting {\n      externalUrl\n    }\n  }\n"),o=e=>(0,s.aM)({query:l,...e}),d=()=>{let[{data:e}]=o(),n=null==e?void 0:e.networkSetting,t=r.useMemo(()=>(null==n?void 0:n.externalUrl)||((0,i.S_)()?new URL(window.location.href).origin:""),[n]);return t}}},function(e){e.O(0,[7565,8415,7430,8516,1652,340,4007,2546,1283,3449,2578,8511,240,4421,2287,8961,9148,3707,389,7288,1565,3240,4656,3375,5289,1744],function(){return e(e.s=24306)}),_N_E=e.O()}]);